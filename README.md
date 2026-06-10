# ⏰ Programar Apagado

Herramienta híbrida para Windows con una interfaz gráfica limpia y moderna que permite programar el apagado del equipo.

![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?style=flat&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat&logo=powershell&logoColor=white)
![Autor](https://img.shields.io/badge/Autor-Jose%20Biojo%20Tenorio-blueviolet?style=flat)
![Licencia](https://img.shields.io/badge/Licencia-Propietaria-red?style=flat)

---

## Modos de uso

Este programa está diseñado para ser versátil y adaptarse a tus necesidades. Al ser un ejecutable híbrido, puedes utilizarlo de tres formas:

| Modo | Descripción |
|---|---|
| **Portátil (Standalone)** | Abre directamente el `.exe` sin instalar nada en el sistema |
| **Integrado (Menú Contextual)** | Usa el botón verde integrado para añadirlo al clic derecho de Windows |
| **Panel de Control** | El mismo `.exe` actúa como desinstalador — el botón cambia a rojo cuando ya está instalado |

---

## Autor

**Jose Biojo Tenorio**
> Si usas o compartes este proyecto, por favor da crédito al autor original.

---

## Descripción

La ventana permite elegir entre tiempos rápidos (15 min, 30 min, 1h, 2h, 4h), ingresar un tiempo personalizado en minutos, cancelar un apagado ya programado, y gestionar la integración con el sistema de Windows.

---

## Instalación (Opcional)

Si deseas integrar la herramienta al menú contextual de Windows, sigue estos pasos.

> Requiere permisos de Administrador únicamente para esta función.

1. Descarga el archivo `ProgramarApagado.exe`
2. Haz clic derecho sobre el archivo y selecciona **"Ejecutar como administrador"**
3. Haz clic en el botón verde **"Agregar al menú contextual (clic derecho)"**

Listo — la opción **"Programar Apagado"** aparecerá en el menú contextual de tu escritorio y carpetas.

---

## Uso

Ya sea abriendo el ejecutable directamente o desde el clic derecho en el escritorio, la interfaz ofrece:

| Opción | Descripción |
|---|---|
| 15 / 30 min · 1h / 2h / 4h | Programa el apagado con un solo clic |
| Tiempo personalizado | Ingresa los minutos exactos que requieras |
| Cancelar apagado programado | Anula cualquier apagado que esté en curso |
| Botón verde / rojo | Instala o desinstala la opción del menú contextual |

---

## Archivos

```
programar-apagado/
├── ProgramarApagado.exe  # Aplicación principal híbrida (uso y gestor de instalación)
├── apagado.ps1           # Código fuente (PowerShell + WinForms)
├── icono.ico             # Icono de la aplicación
├── LICENSE               # Licencia — propiedad de Jose Biojo Tenorio
└── README.md
```

---

## Requisitos

- Windows 10 u 11
- PowerShell 5.1 o superior (incluido en Windows por defecto)
- Permisos de administrador (solo si usas la función de instalar/desinstalar del menú contextual)

---

## Licencia

© 2026 **Jose Biojo Tenorio** — Todos los derechos reservados.
Uso personal permitido. Prohibida la redistribución o uso comercial sin autorización del autor.
