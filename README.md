# ⏰ Programar Apagado

Herramienta para Windows que agrega la opción **"Programar Apagado"** al menú contextual del escritorio (clic derecho), con una interfaz gráfica limpia y moderna.

![Windows](https://img.shields.io/badge/Windows-10%2F11-0078D6?style=flat&logo=windows&logoColor=white)
![PowerShell](https://img.shields.io/badge/PowerShell-5.1%2B-5391FE?style=flat&logo=powershell&logoColor=white)
![Autor](https://img.shields.io/badge/Autor-Jose%20Biojo%20Tenorio-blueviolet?style=flat)
![Licencia](https://img.shields.io/badge/Licencia-Propietaria-red?style=flat)

---

## Autor

**Jose Biojo Tenorio**
> Si usas o compartes este proyecto, por favor da crédito al autor original.

---

## Descripción

La ventana permite elegir entre tiempos rápidos (15 min, 30 min, 1h, 2h, 4h),
ingresar un tiempo personalizado en minutos, o cancelar un apagado ya programado.

---

## Instalación

> **Requiere ejecutar como Administrador** (solo para la instalación).

1. Descarga o clona este repositorio
2. Clic derecho sobre `INSTALAR.bat`
3. Selecciona **"Ejecutar como administrador"**
4. Listo — aparece en el menú contextual del escritorio

```
git clone https://github.com/tu-usuario/programar-apagado.git
cd programar-apagado
```

---

## Uso

1. Clic derecho en el **escritorio** o en cualquier **carpeta**
2. Selecciona **"Programar Apagado"**
3. Elige el tiempo desde la ventana

| Opción | Descripción |
|---|---|
| 15 / 30 min · 1h / 2h / 4h | Apagado con un solo clic |
| Tiempo personalizado | Ingresa los minutos que quieras |
| Cancelar apagado | Anula un apagado ya programado |

---

## Archivos

```
programar-apagado/
├── apagado.ps1       # Interfaz gráfica (PowerShell + WinForms)
├── INSTALAR.bat      # Copia el script y registra el menú contextual
├── DESINSTALAR.bat   # Revierte todo
├── LICENSE           # Licencia — propiedad de Jose Biojo Tenorio
└── README.md
```

---

## Requisitos

- Windows 10 u 11
- PowerShell 5.1 o superior (incluido en Windows por defecto)
- Permisos de administrador (solo para instalar/desinstalar)

---

## Licencia

© 2026 **Jose Biojo Tenorio** — Todos los derechos reservados.
Uso personal permitido. Prohibida la redistribución o uso comercial sin autorización del autor.
