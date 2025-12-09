# Czkawka - Duplicate Photo Finder

**Powerful duplicate file and similar image finder for TrueNAS photo library**

## Overview

Czkawka (Polish for "hiccup") is a fast, multi-threaded duplicate finder that can:
- Find **exact duplicate files** (by hash)
- Find **similar images** (visually similar, even with different resolutions)
- Find duplicate videos, music files
- Very fast performance with multi-threading
- Web GUI for easy management

## Access

- **Web Interface**: https://czkawka.media.erdlabs.com
- **Local**: http://192.168.1.12:5800

## Features

### 1. Duplicate Photos (Exact)
Finds byte-for-byte identical files:
- Same photo copied multiple times
- Renamed duplicates
- Across different folders

### 2. Similar Images
Finds visually similar images:
- Same photo in different resolutions
- Slightly edited versions
- Different compression levels
- Configurable similarity threshold

### 3. Safe Operations
- Photos mounted **read-only** by default
- Duplicates can be moved to `/duplicates` folder
- Review before deletion
- Undo-friendly workflow

## Quick Start

1. **Access Web GUI**: https://czkawka.media.erdlabs.com

2. **Select Search Type**:
   - "Duplicate Files" → Find exact copies
   - "Similar Images" → Find visually similar photos

3. **Configure Search**:
   - **Directory**: `/photos` (your photo library)
   - **Min File Size**: 10 KB (skip thumbnails)
   - **Search Method**: Hash (fastest for exact duplicates)

4. **Run Search**: Click "Search" and wait

5. **Review Results**:
   - Preview images side-by-side
   - Select which copies to keep/delete
   - Move duplicates to `/duplicates` folder

## Configuration

### Scan Paths

| Path | Description | Access |
|------|-------------|--------|
| `/photos` | Main photo library | Read-only (safe) |
| `/duplicates` | Duplicate storage | Read-write |

### Recommended Settings

**For Exact Duplicates:**
```
Mode: Duplicate Files
Hash Type: Blake3 (fastest)
Search in: /photos
Min size: 10 KB
```

**For Similar Images:**
```
Mode: Similar Images
Similarity: High (default)
Search in: /photos
Min size: 50 KB
Image hash: Gradient
```

## Workflow

### Option 1: Safe Review (Recommended)
1. Find duplicates with Czkawka
2. Move to `/duplicates` folder
3. Review with PhotoPrism/Immich
4. Manually delete after verification

### Option 2: Direct Deletion (Advanced)
⚠️ **Requires removing `:ro` flag from docker-compose.yml**
1. Find duplicates
2. Select files to delete
3. Delete directly (use with caution!)

## CLI Usage

For automation, use CLI mode:

```bash
# Find duplicate files
docker exec czkawka czkawka_cli dup -d /photos -D aen

# Find similar images
docker exec czkawka czkawka_cli image -d /photos -D aen

# Results saved to /config/results.txt
```

## Performance Tips

- **First run takes longest** (builds cache)
- **Subsequent runs are fast** (uses cache)
- **Multi-threading**: Utilizes all CPU cores
- **Memory usage**: ~1-2 GB for large libraries

## Integration with PhotoPrism

After finding duplicates:
1. Duplicates moved to `/duplicates` folder
2. PhotoPrism can index both locations
3. Compare side-by-side before deletion
4. PhotoPrism will auto-remove from library

## Troubleshooting

### Web GUI not loading
```bash
docker logs czkawka
docker restart czkawka
```

### Permission issues
Check that USER_ID/GROUP_ID match your photo files:
```bash
ssh truenas "ls -la /mnt/media-pool/photos | head"
```

### Can't delete files
Remove `:ro` flag from `/photos` mount in docker-compose.yml (not recommended)

## Safety Features

✅ **Read-only mount** prevents accidental deletion
✅ **Duplicate folder** for safe staging
✅ **Visual preview** before any action
✅ **Undo-friendly** workflow

## Resources

- **GitHub**: https://github.com/qarmin/czkawka
- **Documentation**: https://github.com/qarmin/czkawka/blob/master/instructions/Instruction.md
- **Docker Image**: https://github.com/jlesage/docker-czkawka

## Deployment

See `.github/workflows/sync-truenas.yml` for CI/CD setup.
