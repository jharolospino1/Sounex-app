# Sounex 🎧

App de música móvil, instalable como app (PWA), con diseño oscuro y acento morado.

## Cómo descargarla e instalarla

1. Publica el repositorio con GitHub Pages: **Settings → Pages → Deploy from a branch → `main` / `(root)`**.
2. Abre `https://TU_USUARIO.github.io/NOMBRE_DEL_REPO/` en el celular.
3. Toca **Descargar** en la pantalla de Inicio (o **Ajustes → Instalar Sounex**).
   - **Android (Chrome):** acepta el aviso de instalación.
   - **iPhone (Safari):** Compartir → *Añadir a pantalla de inicio*.

Una vez instalada se abre a pantalla completa, con su ícono, y funciona sin conexión.

## Qué incluye

- Pantalla de entrada (splash) con animación del nombre
- Inicio, Explorar, Favoritos y Búsqueda
- Mini reproductor y reproductor completo: progreso, repetir, aleatorio, cola, temporizador y letras
- Ajustes completos con subpantallas
- Selector de audio/video con hoja de Premium (de muestra)

## Panel de administración (`admin.html`)

Login de administrador, dashboard, y alta/edición/eliminación de canciones con subida real de audio y portada. Usa Supabase (Auth + base de datos + Storage) y la app principal lee de la misma base.

1. Crea un proyecto en supabase.com.
2. **SQL Editor**: pega `setup.sql` y ejecútalo (tablas, reglas de seguridad y buckets).
3. **Authentication → Users**: crea tu usuario (correo y contraseña). Desactiva el registro público de nuevos usuarios en los ajustes de Auth.
4. Ejecuta en SQL Editor: `insert into public.admins (user_id) select id from auth.users where email = 'TU_CORREO';`
5. **Project Settings → API**: copia *Project URL* y la clave *anon public* en `config.js`.
6. Publica los archivos. El panel queda en `/admin.html`.

Solo las cuentas de la tabla `admins` pueden escribir en la base y en los buckets; cualquier otra cuenta se rechaza en el servidor. Mientras no haya canciones en la base, la app muestra las de ejemplo.

## Estructura

- `index.html`: la app completa
- `admin.html`, `config.js`, `setup.sql`: panel de administración y su configuración
- `manifest.webmanifest`: nombre, colores e íconos de la app instalada
- `sw.js`: guarda la app para que abra sin conexión (si cambias `index.html`, sube el número de `sounex-v2`)
- `icons/`: íconos de la app

## Estado actual

- Las canciones son de ejemplo y la reproducción es simulada (sin audio real).
- Las portadas son degradados de color.
- Premium, letras y transmitir a dispositivos son solo de muestra.

## Próximos pasos

- Subir y reproducir música propia
- Inicio de sesión con cuenta real
