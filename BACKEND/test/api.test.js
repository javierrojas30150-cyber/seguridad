const assert = require("node:assert/strict");
const { after, before, beforeEach, test } = require("node:test");
const { once } = require("node:events");
const jwt = require("jsonwebtoken");

process.env.JWT_SECRET = "test-only-secret-for-api-tests";

const app = require("../src/app");
const { pool } = require("../src/db");

const rolesByUser = new Map([
  [10, "medico"],
  [20, "paciente"],
  [30, "admin"],
]);

let server;
let baseUrl;
const originalQuery = pool.query;

before(async () => {
  server = app.listen(0, "127.0.0.1");
  await once(server, "listening");
  baseUrl = `http://127.0.0.1:${server.address().port}`;
});

after(async () => {
  pool.query = originalQuery;
  await new Promise((resolve, reject) => {
    server.close((error) => (error ? reject(error) : resolve()));
  });
});

beforeEach(() => {
  pool.query = async (statement, values = []) => {
    const sql = statement.replace(/\s+/g, " ").trim();

    if (sql.startsWith("SELECT id, nombre_usuario, contrasena, correo FROM usuarios")) {
      if (values[0] !== "medico") return { rows: [] };
      return {
        rows: [{
          id: 10,
          nombre_usuario: "medico",
          contrasena: "clave-correcta",
          correo: "medico@example.test",
        }],
      };
    }

    if (sql.startsWith("SELECT r.id, r.nombre FROM usuario_roles")) {
      return { rows: [{ id: 2, nombre: "medico" }] };
    }

    if (sql.startsWith("SELECT r.nombre FROM usuario_roles")) {
      const role = rolesByUser.get(values[0]);
      return { rows: role ? [{ nombre: role }] : [] };
    }

    if (sql.startsWith("SELECT id FROM pacientes WHERE usuario_id")) {
      return { rows: values[0] === 20 ? [{ id: 21 }] : [] };
    }

    if (sql.startsWith("INSERT INTO pacientes")) {
      return {
        rows: [{
          id: 44,
          rut: values[0],
          primer_nombre: values[1],
          apellido_paterno: values[2],
          email: values[8],
        }],
      };
    }

    if (sql.startsWith("UPDATE pacientes SET")) {
      return {
        rows: [{ id: Number(values[values.length - 1]), telefono: values[0] }],
      };
    }

    if (sql.startsWith("SELECT p.*, u.nombre_usuario FROM pacientes")) {
      return values[0] === "21"
        ? { rows: [{ id: 21, primer_nombre: "Paciente de prueba" }] }
        : { rows: [] };
    }

    if (sql.includes("WHERE em.id = $1 AND em.paciente_id = $2")) {
      return values[0] === "71" && values[1] === 21
        ? { rows: [{ id: 71, paciente_id: 21, diagnosis: "Control" }] }
        : { rows: [] };
    }

    if (sql.startsWith("SELECT em.paciente_id, p.usuario_id")) {
      return values[0] === "71"
        ? { rows: [{ paciente_id: 21, usuario_id: 20 }] }
        : { rows: [{ paciente_id: 22, usuario_id: 99 }] };
    }

    if (sql.startsWith("SELECT id, nombre_archivo, created_at FROM documentos_examen")) {
      return {
        rows: [{ id: 81, nombre_archivo: "resultado.pdf", created_at: "2026-01-01" }],
      };
    }

    if (sql.startsWith("SELECT de.*, em.paciente_id, p.usuario_id")) {
      return {
        rows: [{
          id: Number(values[0]),
          examen_medico_id: 71,
          paciente_id: values[0] === "81" ? 21 : 22,
          usuario_id: values[0] === "81" ? 20 : 99,
          nombre_archivo: "resultado.pdf",
          documento: Buffer.from("%PDF-1.4 synthetic test file"),
        }],
      };
    }

    if (sql.startsWith("INSERT INTO auditoria")) return { rows: [] };

    throw new Error(`Consulta no simulada en prueba: ${sql}`);
  };
});

function tokenFor(usuarioId) {
  return jwt.sign({ usuarioId }, process.env.JWT_SECRET);
}

async function request(path, { method = "GET", token, body } = {}) {
  const headers = {};
  if (token) headers.Authorization = `Bearer ${token}`;
  if (body) headers["Content-Type"] = "application/json";

  const response = await fetch(`${baseUrl}${path}`, {
    method,
    headers,
    body: body ? JSON.stringify(body) : undefined,
  });
  const text = await response.text();
  return {
    status: response.status,
    body: text ? JSON.parse(text) : null,
  };
}

async function requestRaw(path, { token } = {}) {
  const headers = {};
  if (token) headers.Authorization = `Bearer ${token}`;
  const response = await fetch(`${baseUrl}${path}`, { headers });
  return {
    status: response.status,
    contentType: response.headers.get("content-type"),
    bytes: Buffer.from(await response.arrayBuffer()),
  };
}

const pacienteNuevo = {
  rut: "12.345.678-5",
  primer_nombre: "Ana",
  apellido_paterno: "Prueba",
  fecha_nacimiento: "1990-01-01",
  sexo: "F",
  email: "ana@example.test",
};

test("login válido entrega un token firmado con el rol", async () => {
  const response = await request("/autenticacion/login", {
    method: "POST",
    body: { nombre_usuario: "medico", password: "clave-correcta" },
  });

  assert.equal(response.status, 200);
  assert.equal(jwt.verify(response.body.token, process.env.JWT_SECRET).rolNombre, "medico");
});

test("login con contraseña incorrecta se rechaza", async () => {
  const response = await request("/autenticacion/login", {
    method: "POST",
    body: { nombre_usuario: "medico", password: "incorrecta" },
  });

  assert.equal(response.status, 401);
});

test("médico autenticado puede crear un paciente válido", async () => {
  const response = await request("/pacientes", {
    method: "POST",
    token: tokenFor(10),
    body: pacienteNuevo,
  });

  assert.equal(response.status, 201);
  assert.equal(response.body.id, 44);
});

test("administrador autenticado puede crear un paciente válido", async () => {
  const response = await request("/pacientes", {
    method: "POST",
    token: tokenFor(30),
    body: pacienteNuevo,
  });

  assert.equal(response.status, 201);
  assert.equal(response.body.id, 44);
});

test("paciente no puede crear otro paciente", async () => {
  const response = await request("/pacientes", {
    method: "POST",
    token: tokenFor(20),
    body: pacienteNuevo,
  });

  assert.equal(response.status, 403);
});

test("paciente puede consultar solo su propio registro", async (t) => {
  await t.test("registro propio", async () => {
    const response = await request("/pacientes/21", { token: tokenFor(20) });
    assert.equal(response.status, 200);
    assert.equal(response.body.id, 21);
  });

  await t.test("registro de otra persona", async () => {
    const response = await request("/pacientes/22", { token: tokenFor(20) });
    assert.equal(response.status, 403);
  });
});

test("paciente puede actualizar su registro, pero no el de otra persona", async (t) => {
  await t.test("actualización propia", async () => {
    const response = await request("/pacientes/21", {
      method: "PUT",
      token: tokenFor(20),
      body: { telefono: "+56911112222" },
    });
    assert.equal(response.status, 200);
    assert.equal(response.body.telefono, "+56911112222");
  });

  await t.test("actualización ajena", async () => {
    const response = await request("/pacientes/22", {
      method: "PUT",
      token: tokenFor(20),
      body: { telefono: "+56911112222" },
    });
    assert.equal(response.status, 403);
  });
});

test("paciente puede consultar solo exámenes asociados a su cuenta", async (t) => {
  await t.test("examen propio", async () => {
    const response = await request("/examenes/71", { token: tokenFor(20) });
    assert.equal(response.status, 200);
    assert.equal(response.body.paciente_id, 21);
  });

  await t.test("examen de otra persona", async () => {
    const response = await request("/examenes/72", { token: tokenFor(20) });
    assert.equal(response.status, 404);
  });
});

test("paciente puede ver y descargar documentos propios, pero no ajenos", async (t) => {
  await t.test("documentos de examen propio", async () => {
    const response = await request("/documentos/examen/71", { token: tokenFor(20) });
    assert.equal(response.status, 200);
    assert.equal(response.body[0].nombre_archivo, "resultado.pdf");
  });

  await t.test("descarga de documento propio", async () => {
    const response = await requestRaw("/documentos/81", { token: tokenFor(20) });
    assert.equal(response.status, 200);
    assert.equal(response.contentType, "application/pdf");
    assert.equal(response.bytes.toString(), "%PDF-1.4 synthetic test file");
  });

  await t.test("documentos de examen ajeno", async () => {
    const response = await request("/documentos/examen/72", { token: tokenFor(20) });
    assert.equal(response.status, 403);
  });

  await t.test("descarga de documento ajeno", async () => {
    const response = await requestRaw("/documentos/82", { token: tokenFor(20) });
    assert.equal(response.status, 403);
  });
});
