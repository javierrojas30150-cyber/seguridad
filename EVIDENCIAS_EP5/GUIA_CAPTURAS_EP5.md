# Guia de capturas para la defensa EP5

Guarda las capturas finales en `EVIDENCIAS_EP5/capturas/`. Usa nombres secuenciales y conserva la barra de direcciones o el comando cuando sirvan para probar el contexto.

## Antes de comenzar

1. Inicia Docker Desktop y espera a que indique que el motor esta activo.
2. Desde la raiz `CodigoFuenteB`, ejecuta:

   ```powershell
   docker compose up -d --build
   docker compose ps
   ```

3. Continua solo cuando PostgreSQL aparezca como saludable y backend/frontend como activos. Si falla, guarda el error para corregirlo; no presentes una captura de servicios caidos como evidencia de funcionamiento.
4. Usa exclusivamente cuentas y datos ficticios. No muestres contrasenas, tokens JWT, RUT reales, resultados medicos reales, secretos de `.env` ni datos personales de terceros.
5. Captura con `Windows + Shift + S`, pega/guarda cada imagen en `EVIDENCIAS_EP5/capturas/`. Evita capturas borrosas, recortadas o con notificaciones del escritorio.

## Capturas principales

| Archivo sugerido | Que debe aparecer | Como prepararla |
|---|---|---|
| `CAP-01-docker-servicios.png` | Salida de `docker compose ps`: tres servicios activos y PostgreSQL saludable. | Terminal en la raiz del proyecto. No incluyas variables de entorno. |
| `CAP-02-login.png` | Pantalla de inicio de sesion y URL local. | Abrir `http://localhost:3333/login`; no escribir la contrasena antes de capturar. |
| `CAP-03-inicio-sesion.png` | Vista principal despues de autenticarse, con el rol visible si la interfaz lo muestra. | Iniciar con una cuenta descartable/local; oculta nombre/correo si no son ficticios. |
| `CAP-04-pacientes.png` | Flujo de listado o formulario de paciente y una validacion visible. | Usar un paciente sintetico; evita mostrar RUT/datos reales. |
| `CAP-05-examen.png` | Consulta o detalle de un examen asociado a datos ficticios. | No fotografies diagnosticos ni tratamientos reales. |
| `CAP-06-resultados-documentos.png` | Resultados/documentos propios vistos desde el rol paciente; si procede, descarga autorizada. | Comprueba que sea un registro de prueba y no una ficha real. |
| `CAP-07-acceso-denegado.png` | Rechazo de una accion o recurso ajeno, sin revelar el contenido protegido. | Puedes usar la evidencia automatizada de rol/aislamiento si el flujo visual no esta disponible; indica que es salida de pruebas. |
| `CAP-08-swagger.png` | Swagger UI y endpoint de salud de la API. | Captura `http://localhost:4444/docs`; opcionalmente otra de `http://localhost:4444/`. |
| `CAP-09-pruebas-api.png` | Resumen final con `tests 19`, `pass 19`, `fail 0`. | Ejecuta `npm.cmd test` dentro de `BACKEND`; el log tambien queda en `ejecucion-pruebas-backend.txt`. |
| `CAP-10-hallazgos.png` | Tabla de hallazgos, criticidad y mitigaciones del informe. | Abre la seccion 5.2/6.1 del Word; no la presentes como resultado de ZAP. |

## Seguridad dinamica (pendiente)

Cuando Docker este activo, ejecuta una revision **pasiva/baseline** con OWASP ZAP solo contra esta instancia local autorizada. No uses produccion ni servicios de terceros. Guarda el resumen con el alcance, fecha, herramienta y severidad en `CAP-11-zap-baseline.png`; revisa falsos positivos antes de incorporarlos al informe. No afirmes que la aplicacion esta libre de vulnerabilidades por obtener cero alertas.

## Revisión antes de entregar

- Cada captura esta numerada, es legible y coincide con el texto del informe.
- Se ocultaron credenciales, tokens, datos personales y cualquier secreto.
- El nombre del archivo describe la evidencia; no se mezclan capturas de ejecuciones distintas.
- Actualiza el informe y el checklist solo con resultados que realmente hayas observado.
- No elimines volumenes con `docker compose down -v`: podria borrar la base de datos local.

**Estado actual:** esta guia y la carpeta de capturas quedan preparadas. Durante esta revision Docker no pudo conectarse al daemon; aun no hay capturas reales de la aplicacion levantada ni de ZAP.
