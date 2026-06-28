# Stack Compliance Matrix

## Expected vs Actual Stack

| Expected stack from brief | Actual stack found | Compliance | Evidence |
|---|---|---|---|
| Python | No Python app/runtime found in inspected frontend/backend stack | Missing / mismatch | Frontend uses Flutter/Dart in `pubspec.yaml`; backend uses Node/CommonJS in `..\projet_pfe_backend\package.json` |
| React | Frontend is Flutter, not React | Mismatch | `pubspec.yaml` defines a Flutter app with Dart dependencies such as `flutter`, `flutter_riverpod`, `go_router`, `mobile_scanner`, `http`, `shared_preferences` |
| Node JS | Node.js backend is present | Match | `..\projet_pfe_backend\package.json` includes `express`, `jsonwebtoken`, `multer`, `nodemailer`, `pg`, Prisma, and scripts `node server.js` / `nodemon server.js` |
| Machine Learning | No ML framework or model-serving stack found in current codebase | Missing for now / planned later | No Python ML libraries or Node ML packages in inspected manifests; schema only shows AI-ready fields like `Recipe.isAiGenerated` and `ChatMessage.modelUsed` in `..\projet_pfe_backend\prisma\schema.prisma` |
| MySQL | Database is PostgreSQL, not MySQL | Mismatch | `..\projet_pfe_backend\prisma\schema.prisma` sets `datasource db { provider = "postgresql" }`; backend also depends on `pg` and `@prisma/adapter-pg` in `..\projet_pfe_backend\package.json` |

## Concise Assessment

- **Matches:** Node JS backend is implemented.
- **Major mismatches:** Expected **React** frontend is actually **Flutter/Dart**; expected **MySQL** is actually **PostgreSQL**; expected **Python** is not present in the inspected stack.
- **AI/ML status:** The project appears **AI-prepared but not AI-implemented yet**. That aligns with the note that **“AI will be integrated soon.”**
  - This means the absence of machine learning code should be treated as **not yet completed**, rather than a hard failure if current scope is MVP/app foundation.
  - Evidence of future AI support exists in backend schema fields:
    - `Recipe.isAiGenerated`
    - `ChatMessage.modelUsed`
    - `ChatMessage.tokensUsed`
    - `ChatMessage.isBot`
- **Overall stack compliance:** **Partial compliance** with the brief. Functional foundation exists on a different stack than expected.

## Bottom-line Matrix

| Area | Status |
|---|---|
| Frontend stack compliance | Partial / mismatch |
| Backend stack compliance | Mostly aligned on Node, but not Python |
| Database compliance | Not compliant with MySQL expectation |
| AI/ML compliance today | Not implemented yet |
| AI/ML compliance considering “integrated soon” | Acceptable as planned/in-progress, but still currently missing |