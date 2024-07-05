# mech jam project

## basic overview of high level systems

- `enemy_factory.gd` - used to spawn new enemies and specify types
- `game_manager.gd` - defines the waves of enemies spawning according to difficulties, and other game state items, like game over, and player score
- `scroll_manager.gd` - based on the defined time scale, returns back a 0-1 difficulty score usable by the game manager to determine which enemies to spawn


## scene tree

![current scene tree](/documentation/images/image.png)

## additional libraries

- bulletuphell library for bullet hell mechanics
- maack's game template for scene loading, transitions, menus, saving player score, 
