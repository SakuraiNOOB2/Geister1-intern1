using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ButtonClick : MonoBehaviour
{
    public bool Click;

    // Start is called before the first frame update
    void Start()
    {
        Click = false;
    }

    public void OnClick()
    {
        Click = true;
    }
}
