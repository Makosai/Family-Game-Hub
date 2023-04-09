using BoardGeneration;
using UnityEngine;

public class BoardGen_4InARow : BoardGenerator
{
    public override event MyBoardGenerator Generate;

    public BoardGen_4InARow()
    {
        Generate = Generator;
    }

    public override BoardData Generator(int x, int y, Sprite[] boardTiles)
    {
        return new BoardData(x, y, boardTiles[0]);
    }

    void CreateBoard(int _sizeX, int _sizeY)
    {
        if(_sizeX <= 0 || _sizeY <= 0)
        {
            Debug.Log("The size of the grid must at least be 1 by 1.");
            return;
        }

        Debug.Log("Generating a 4 in a Row board.");

        for(int x = 0; x < _sizeX; x++)
        {
            for(int y = 0; y < _sizeY; y++)
            {
                Debug.Log($"Generating {x} and {y}");

                BoardData data = Generate.Invoke(x, y, boardTiles);

                GameObject tile = new GameObject($"4InARowBoard-{x}_{y}");

                SpriteRenderer spr = tile.AddComponent<SpriteRenderer>();
                spr.sprite = data.sprite;

                // Offset by the size of the sprite
                float xPos = x == 0 ? 0 : x * data.sprite.bounds.size.x;
                float yPos = y == 0 ? 0 : y * data.sprite.bounds.size.y;

                tile.transform.position = new Vector2(xPos, yPos);

                tile.transform.SetParent(transform);
            }
        }
    }

    void Start()
    {
        CreateBoard(sizeX, sizeY);
    }
}