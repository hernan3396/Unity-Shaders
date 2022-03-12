using UnityEngine;
using System.Collections;

public class FlickeringLight : MonoBehaviour
{
    [SerializeField] private Light spotLight;

    private IEnumerator LightFlickering(string pattern)
    {
        foreach (char letter in pattern)
        {
            //TODO: Hacer el resto del codigo
        }

        yield return null;
    }
}
