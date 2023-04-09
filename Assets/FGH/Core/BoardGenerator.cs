using UnityEngine;

namespace BoardGeneration
{
    public delegate BoardData MyBoardGenerator(int x, int y, Sprite[] boardTiles);

    public abstract class BoardGenerator : MonoBehaviour, IBoardGenerator
    {
        public int sizeX, sizeY;
        public Sprite[] boardTiles;

        public abstract event MyBoardGenerator Generate;

        public abstract BoardData Generator(int x, int y, Sprite[] boardTiles);
    }

    public interface IBoardGenerator
    {

        event MyBoardGenerator Generate;

        /// <summary>
        /// The action to perform when generating the board.
        /// </summary>
        /// <param name="x"></param>
        /// <param name="y"></param>
        /// <param name="boardTiles"></param>
        /// <returns></returns>
        BoardData Generator(int x, int y, Sprite[] boardTiles);
    }

    public struct BoardData
    {
        public int x, y;
        public Sprite sprite;

        public BoardData(int x, int y, Sprite sprite)
        {
            this.x = x;
            this.y = y;
            this.sprite = sprite;
        }
    }
}