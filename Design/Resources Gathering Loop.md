# Resources Gathering Loop

1. Workers are simple **GameActors** spawned into the world.
2. **CityStructures** spawn with a set of **CraftTools** in their **Inventory.**
3. Each **CityStructure** registers with the **QuarterMaster** for each **CraftTool** in its **Inventory.**
4. Idle **GameActors** get assigned occupations at **CityStructures.**
5. Assigned **GameActors** will gather the **CraftTool** from their employer.
6. Each **CraftTool** defines a **GameActors** behaviour.



