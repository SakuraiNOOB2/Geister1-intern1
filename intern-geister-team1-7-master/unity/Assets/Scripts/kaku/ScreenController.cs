using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using UnityEngine;

public class ScreenController : MonoBehaviour
{

    // スプライトが大きさを合わせたいカメラ
    [SerializeField] private Camera mainCamera;

    // コンポーネントのキャッシュ
    [SerializeField, HideInInspector] private SpriteRenderer spriteRender;
    [SerializeField, HideInInspector] private Transform _transform;

    public GameObject background;


    // コンポーネント登録時に事前計算（or コンテキストメニューのReset）
    void Awake()
    {
        // コンポーネントのキャッシュ
        spriteRender = background.GetComponent<SpriteRenderer>();
        _transform = background.GetComponent<Transform>();

        // MainCameraを取得し、カメラの中央まで移動
        mainCamera = GameObject.FindGameObjectWithTag("MainCamera").GetComponent<Camera>();
        _transform.position = mainCamera.transform.position + mainCamera.transform.forward;

    }

    void Update()
    {
        UpdateSpritesize();
    }

    void UpdateSpritesize()
    {
        // スプライトのアスペクト比を取得。
        var sprite = spriteRender.sprite;
        var spriteaspect = sprite.rect.width / sprite.rect.height;

        // アス比に合わせてスプライトのサイズを変更
        if (mainCamera.aspect > spriteaspect)
        {
            var spritesize = sprite.rect.height / sprite.pixelsPerUnit * 0.5f;
            var screenrate = Camera.main.orthographicSize / spritesize;
            _transform.localScale = Vector3.one * screenrate;
        }
        else
        {
            var spritesize = sprite.rect.width / sprite.pixelsPerUnit * 0.5f;
            var screenrate = Camera.main.orthographicSize * Camera.main.aspect / spritesize;
            _transform.localScale = Vector3.one * screenrate;
        }
    }
}
