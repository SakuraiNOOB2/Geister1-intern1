using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class Login : MonoBehaviour
{
    [Tooltip("ログインを管理するボタンを格納 (Button)")]
    public Button[] titleButtons;

    [Tooltip("SEを格納 (AudioClip[])")]
    public AudioClip[] SoundEffects;
    public bool[] soundEffectFlg;
    private AudioSource audioSource;

    public enum SoundEffect
    {
        MENU,
        LOGIN,
        MAX
    }

    private void Awake()
    {

        audioSource = GetComponent<AudioSource>();

        soundEffectFlg = new bool[(int)SoundEffect.MAX];
        for (int i = 0; i < soundEffectFlg.Length; i++)
            soundEffectFlg[i] = true;


        if (soundEffectFlg[(int)SoundEffect.MENU])
        {
            audioSource.PlayOneShot(SoundEffects[(int)SoundEffect.MENU]);
            soundEffectFlg[(int)SoundEffect.MENU] = false;
        }
        soundEffectFlg[(int)SoundEffect.MENU] = true;
    }

    private void Update()
    {

        if (titleButtons[0].GetComponent<ButtonClick>().Click)
        {
            
            SceneManager.LoadScene("MainGame");
        }

    }

}
