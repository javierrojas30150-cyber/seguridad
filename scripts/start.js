const path = require("node:path");
const { spawn } = require("node:child_process");

const backendPort = process.env.PORT || "3000";

const services = [
  {
    name: "Backend",
    cwd: path.join(__dirname, "..", "BACKEND"),
    args: ["src/app.js"],
    env: { PORT: backendPort },
  },
  {
    name: "Frontend",
    cwd: path.join(__dirname, "..", "FRONTEND"),
    args: ["node_modules/vite/bin/vite.js"],
    env: {
      VITE_API_URL:
        process.env.VITE_API_URL || `http://localhost:${backendPort}`,
    },
  },
];

const children = [];
let stopping = false;

function stopServices(exitCode) {
  if (stopping) return;
  stopping = true;
  process.exitCode = exitCode;
  children.forEach((child) => child.kill());
}

for (const service of services) {
  const child = spawn(process.execPath, service.args, {
    cwd: service.cwd,
    env: { ...process.env, ...service.env },
    stdio: "inherit",
  });
  children.push(child);

  child.on("error", (error) => {
    console.error(`${service.name} no pudo iniciarse: ${error.message}`);
    stopServices(1);
  });

  child.on("exit", (code, signal) => {
    if (!stopping) {
      console.error(
        `${service.name} finalizó inesperadamente (${signal || code}).`
      );
      stopServices(code || 1);
    }
  });
}

process.on("SIGINT", () => stopServices(0));
process.on("SIGTERM", () => stopServices(0));
