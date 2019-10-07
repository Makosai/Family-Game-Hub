using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Card : MonoBehaviour, IComparable<Card> {
  public Sprite sprite;
  public byte value;
  public string suit;

  // Start is called before the first frame update
  void Start() {
    value = ConvertVal(sprite.name);

    suit = GetSuit(sprite.name);

    name = GetCardName(sprite.name);
  }

  // Update is called once per frame
  void Update() {

  }

  public int Compare(Card x, Card y) {
    int xVal = ConvertVal(x.sprite.name);
    int yVal = ConvertVal(y.sprite.name);

    if (xVal == 0 || yVal == 0) {
      return 0;
    }

    return xVal.CompareTo(yVal);
  }

  public int CompareTo(Card card) {
    return this.value.CompareTo(card.value);
  }

  public byte ConvertVal(string name) {
    string prefix = name.Substring(0, name.IndexOf("_"));

    byte val = 0;
    bool convertable = byte.TryParse(prefix, out val);

    if (convertable == true) {
      return val;
    } else {
      switch (prefix) {
        case "A":
          return 1;

        case "J":
          return 11;

        case "Q":
          return 12;

        case "K":
          return 13;

        case "Back":
          return 14;

        case "Joker":
          return 15;

        default:
          return 0;
      }
    }
  }

  public string GetCardName(string name) {
    return name.Substring(0, sprite.name.IndexOf("_")) + " of " + GetSuit(name);
  }

  public string GetSuit(string name) {
    return name.Substring(sprite.name.IndexOf("_") + 1);
  }
}