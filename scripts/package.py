from pathlib import Path
import zipfile

ROOT = Path(__file__).resolve().parent.parent
ADDON = "LevelPercent"
DIST = ROOT / "dist"
DIST.mkdir(exist_ok=True)

zip_path = DIST / f"{ADDON}.zip"

with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as z:
    for path in (ROOT / ADDON).rglob("*"):
        if path.is_file():
            z.write(path, path.relative_to(ROOT))

print(f"Addon empaquetado en: {zip_path}")
