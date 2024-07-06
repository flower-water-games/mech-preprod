# Technical Details

## Game Flow

1. The ScrollManager, defined by a set time (e.g., 60s) and a difficulty curve, provides progress updates to the GameManager.
2. The GameManager spawns enemies based on the current difficulty throughout the game.
3. Once the ScrollManager completes its cycle, the GameManager checks if all enemies are cleared.
4. The game ends when either:
   - All enemies are cleared after the ScrollManager completes (CURRENT win condition)
   - The player dies (lose condition)
5. At the ScrollManager's scroll completion, team should hook in a custom boss fight for extended gameplay.

## Detailed Script Overview

### Enemy
- `enemy.gd`: 
- `enemy_factory.gd`: Handles enemy creation, spawning, and specifies enemy types.

### Managers
- `game_manager.gd`: Oversees game state, score, and overall game flow.
- `scroll_manager.gd`: Based on the defined game time and a tweakable difficulty curve, returns a 0-1 difficulty score (or raw progress) usable by the GameManager to determine enemy spawning.

### Player
- `bullet.gd`: Extends `CharacterBody2D`. Controls bullet behavior, movement, damage, collision.
- `gun.gd`: Handles spawning bullet and managing fire rate and user input
- `health.gd`: Manages player health and damage system. Also used by `Enemy`.
- `movement.gd`: Extends `CharacterBody2D`. Controls player movement and physics. Stores a reference to health.

## Scene Structure

### Main Game Scene
`/scenes/GameScene/MainGameScene.tscn` contains all components for the core gameplay.

### Components
`/Components` contains all instanceable, composable, or inheritable scenes, including:
- Bullets
- Enemies
- Health component

### Enemy Variants
`/EnemyVariants` contains all inherited enemies from the `enemy_2d.tscn` scene. Devs should:
- Place all custom enemy types here
- Only modify `enemy_2d.tscn` when necessary
- Check all variants after modifying the base enemy scene

## Remote Game Scenes and Autoloads

When the game is running, several autoloads have been initialized and are running:

- **AppConfig**: Stores and provides access to persistent player data.
- **SceneLoader**: Facilitates transitions between scenes (currently used for win/lose states).
- **ProjectMusicController**: Detects any `AudioStreamPlayer` nodes with autoplay enabled for background music and handles music transitions.
- **ProjectUISoundsController**: Manages UI sound effects.


## MainGameScene Hierarchy

The main game scene is structured as follows:

- **Services**: Contains all game managers and menu controllers
  - EnemyFactory
  - GameManager
  - ScrollManager
  - PauseMenuController (from Maaack's game template)
  - InGameMenuController (from Maaack's game template)
- **World2D**: Houses all entities existing in the game world
- **CanvasLayer**: Contains UI elements (currently only a single label)

## Additional Libraries

The project utilizes [Maaack's game template](https://github.com/Maaack/Godot-Game-Template) for:
- Scene loading
- Transitions
- Menu systems
- Saving player scores

Refer to the [template documentation](/addons/maaacks_game_template/docs/NewProject.md) for more details on these systems.
