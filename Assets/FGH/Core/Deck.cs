using System.Collections.Generic;
using UnityEngine;

public class Deck : IComparer<Sprite>
{
    public int Compare(Sprite x, Sprite y)
    {
        int xVal = ConvertVal(x.name);
        int yVal = ConvertVal(y.name);

        if(xVal == 0 || yVal == 0)
        {
            return 0;
        }

        return xVal.CompareTo(yVal);
    }

    public byte ConvertVal(string name)
    {
        string prefix = name.Substring(0, name.IndexOf("_"));

        byte val = 0;
        bool convertable = byte.TryParse(prefix, out val);

        if(convertable == true)
        {
            return val;
        }
        else
        {
            switch(prefix)
            {
                case "A":
                    return 1;

                case "J":
                case "Q":
                case "K":
                    return 11;

                case "Back":
                    return 12;

                case "Joker":
                    return 13;

                default:
                    return 0;
            }
        }
    }
}