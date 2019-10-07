using System.Collections;
using System.Collections.Generic;
using System.Linq;
using UnityEngine;

[System.Serializable]
public class Dealer : MonoBehaviour {
  /// <summary>
  /// The deck with all cards, backs, and jokers.
  /// </summary>
  public Texture2D deck;

  // The deck's sliced sprites.
  public List<Card> fullCards = new List<Card>();

  public List<Card> cards = new List<Card>();

  // Start is called before the first frame update
  void Start() {
    Debug.Log("Loading the deck...");

    foreach(Sprite sprite in Resources.LoadAll<Sprite>(deck.name)) {
      GameObject gO = new GameObject();

      Card card = gO.AddComponent<Card>();

      card.sprite = sprite;

      fullCards.Add(card);
    }

    fullCards = fullCards.GroupBy(card => card.suit)
    .OrderByDescending(card => card.Count())
    .SelectMany(card => card.OrderByDescending(c => c.value)).ToList();

    cards = fullCards.GetRange(0, 52);

    Debug.Log(fullCards);

    Debug.Log(cards);
  }

  // Update is called once per frame
  void Update() {

  }

}