# 11 — Aplicación adicional (propuesta)

Objetivo: Añadir una pequeña aplicación que demuestre integración con el servidor (API o servicio web) y aporte funcionalidad para la entrega.

Propuesta rápida (Recomendado): Node.js + Express

Requerimientos mínimos
- Endpoints: GET / (status), GET /api/items, POST /api/items
- Persistencia: JSON-file local o SQLite (sencillo para la entrega)
- Contenerización: Dockerfile y docker-compose para desplegar en compose/app/

Estructura sugerida
- app/
  - package.json
  - src/index.js
  - Dockerfile
  - data/db.sqlite (opcional)

Pasos para implementar
1. Definir requisitos funcionales y endpoints (docs/11-app-adicional.md) — tarea: app-adicional/definir-requisitos
2. Elegir stack (Node.js/Express recomendado) — tarea: app-adicional/elegir-stack
3. Crear Dockerfile y docker-compose (compose/app/docker-compose.yml) — tarea: app-adicional/crear-compose
4. Implementar prototipo mínimo (CRUD básico in-memory o SQLite) — tarea: app-adicional/implementar-prototipo
5. Integrar documentación y ejemplos de curl en README — tarea: app-adicional/integrar-readme

Notas de despliegue
- Puerto sugerido: 8081 (externo) mapeado a 8080 interno.
- Para pruebas locales: docker compose up -d en compose/app/

Criterios de aceptación
- Servicio inicia en contenedor y responde GET / con 200
- Endpoints API funcionan según ejemplos en la documentación
- README actualizado con pasos de despliegue y pruebas
