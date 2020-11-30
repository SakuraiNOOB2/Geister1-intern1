using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.Tracing;
using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.Tilemaps;
using UnityEngine.UI;
using UnityEngine.SceneManagement;

public class GameController : MonoBehaviour
{
    public enum SoundEffect
    {
        BADGHOST_EAT,
        GOODGHOST_EAT,
        ISMOVE_1,
        ISMOVE_2,
        LOSE,
        LOSING,
        WIN,
        WINNING,
        SELECT,
        GAMESTART,
        
        MAX
    }

    [Tooltip("初期配置モードかどうか (static bool)")]
    public static bool isSetup;

    [SerializeField]
    public static bool[] isOnCorner;

    [Tooltip("現在のターンでどちらが動かすかを格納")]
    public static GhostController.CHECK_PLAYER PlayerTurn;

    [Tooltip("経過したターン数 (static int)")]
    public static int turnCount;

    [Tooltip("プレイヤーの経過したターン数 (static int)")]
    private static int[] playerTurnCount;

    [Tooltip("ケースのマス目の分割数 (Vector2)")]
    public static Vector2 caseSplit = new Vector2(4, 2);

    public static GhostController.CHECK_PLAYER winState;


    [Tooltip("選択する時表示するマーク (GameObject)")]
    public GameObject selectedObject;

    [Tooltip("設置モードの完了を管理するボタンを格納 (Button)")]
    public Button[] setupReadyButton;

    [Tooltip("ゲームモード以外を管理するボタンを格納 (Button)")]
    public Button[] otherButton;

    [Tooltip("ゲームの結果を表示する画像を格納 (Image)")]
    public Image[] gameResultImage;

    [Tooltip("プレイヤーごとのコマ置き場のスタート位置を格納 (GameObject)")]
    public GameObject[] deadPoint;

    [Tooltip("SEを格納 (AudioClip[])")]
    public AudioClip[] SoundEffects;
    public bool[] soundEffectFlg;

    //プレイヤー1の食べたコマの数
    public int[] player1EatCount;
    //プレイヤー1の食べたコマの数
    public int[] player2EatCount;

    [Tooltip("タイルをすべてリフレッシュするときに使うスタートポイント (GameObject)")]
    public GameObject refreshStartPoint;

    [SerializeField]
    private GhostController.CHECK_PLAYER onCornerTurn;

    private Tilemap controlArea;
    private GameObject[] allGhost;

    private GameObject selectedGhost;
    private GhostController selectedcsGC;
    private GameObject oldSelectedGhost;

    private AudioSource audioSource;

    [Tooltip("タイルの色 (Color)")]
    public Color tileColor;

    // Start is called before the first frame update
    void Start()
    {
        //最初のターンをランダムに決める
        PlayerTurn = (GhostController.CHECK_PLAYER)Random.Range(0, 2);
        Debug.Log("ターン : " + PlayerTurn);

        //初期化
        tileColor = new Color(68.0f / 255.0f, 253.0f / 255.0f, 75.0f / 255.0f, 200.0f / 255.0f);

        isSetup = true;
        isOnCorner = new bool[2];
        for (int i = 0; i < isOnCorner.Length; i++)
            isOnCorner[i] = false;
        turnCount = 1;
        onCornerTurn = GhostController.CHECK_PLAYER.NONE;
        player1EatCount = new int[2];
        player2EatCount = new int[2];

        soundEffectFlg = new bool[(int)SoundEffect.MAX];
        for (int i = 0; i < soundEffectFlg.Length; i++)
            soundEffectFlg[i] = true;

        playerTurnCount = new int[2];        
        for(int i = 0; i < playerTurnCount.Length; i++)
        {
            playerTurnCount[i] = 0;
        }

        audioSource = GetComponent<AudioSource>();

        //コマをすべて取得
        allGhost = GameObject.FindGameObjectsWithTag("Ghost");

        //勝負状況の初期化
        winState = GhostController.CHECK_PLAYER.NONE;

        //ゲームの結果の画像を非表示にする処理
        for(int i=0;i<gameResultImage.Length;i++)
        {
            gameResultImage[i].gameObject.SetActive(false);
        }

        selectedObject.SetActive(false);
    }

    // Update is called once per frame
    void Update()
    {
        Debug.Log("ターン数 : " + turnCount);
        Debug.Log("プレイヤー : " + PlayerTurn);

        //選択したボタンの強調表示処理
        for (int i = 0; i < allGhost.Length; i++)
        {

            GhostController csGC = allGhost[i].GetComponent<GhostController>();

            if (csGC.isSelected)
            {
                selectedGhost = allGhost[i];
                selectedcsGC = csGC;
                break;
            }

        }
        //選択されているゴーストが変わっていた場合1度だけ処理
        if (oldSelectedGhost != selectedGhost)
        {
            RefreshTileColor();
        }

        //退室ボタンが押された場合
        if (setupReadyButton[2].GetComponent<ButtonClick>().Click)
        {

        }
        //降参ボタンが押された場合
        if(setupReadyButton[3].GetComponent<ButtonClick>().Click)
        {
            winState = GhostController.CHECK_PLAYER.PLAYER2;
        }

        if (otherButton[0].GetComponent<ButtonClick>().Click)
        {
            SceneManager.LoadScene("Title");

        }

        //お互いのプレイヤーが設置モードのボタンを押したかを判定
        if (setupReadyButton[0].GetComponent<ButtonClick>().Click == true &&
            setupReadyButton[1].GetComponent<ButtonClick>().Click == true)
        {
            Debug.Log("ゲームスタート！");
            //セットアップモード終了
            isSetup = false;
            //準備完了ボタンを非表示にする
            setupReadyButton[0].gameObject.SetActive(false);
            setupReadyButton[1].gameObject.SetActive(false);

            //ターンと同じコマの画像を切り替え
            for (int i = 0; i < allGhost.Length; i++)
            {
                GhostController csGC = allGhost[i].GetComponent<GhostController>();

                if (csGC.alive == true)
                {
                    if (csGC.playerID == PlayerTurn/* && csGC.alive == true*/)
                    {
                        csGC.SetGhostMask(GhostController.GHOST_MASK.REAL);
                    }
                    else
                    {
                        csGC.SetGhostMask(GhostController.GHOST_MASK.UNKNOWN);
                    }
                }
                
            }

            //SEを鳴らす
            if (soundEffectFlg[(int)SoundEffect.GAMESTART])
            {
                audioSource.PlayOneShot(SoundEffects[(int)SoundEffect.GAMESTART]);
                soundEffectFlg[(int)SoundEffect.GAMESTART] = false;
            }
        }
        else if(setupReadyButton[0].GetComponent<ButtonClick>().Click == true)
        {
            setupReadyButton[0].gameObject.SetActive(false);
            for (int i = 0; i < allGhost.Length; i++)
            {

                GhostController csGC = allGhost[i].GetComponent<GhostController>();

                if (csGC.playerID==GhostController.CHECK_PLAYER.PLAYER1 &&csGC.alive==true&&csGC.deadProcess==false)
                {
                    csGC.SetGhostMask(GhostController.GHOST_MASK.UNKNOWN);
                }

            }

        }
        else if (setupReadyButton[1].GetComponent<ButtonClick>().Click == true)
        {
            setupReadyButton[1].gameObject.SetActive(false);
            for (int i = 0; i < allGhost.Length; i++)
            {

                GhostController csGC = allGhost[i].GetComponent<GhostController>();

                if (csGC.playerID == GhostController.CHECK_PLAYER.PLAYER2 && csGC.alive == true && csGC.deadProcess == false)
                {
                    csGC.SetGhostMask(GhostController.GHOST_MASK.UNKNOWN);
                }

            }
        }
        else
        {
            setupReadyButton[0].gameObject.SetActive(true);
            setupReadyButton[1].gameObject.SetActive(true);
        }


        //選択したボタンの強調表示処理


        if (selectedcsGC != null)
        {

            Vector3 tempSelectPos = GhostController.playArea.CellToWorld(selectedcsGC.tilePosition);
            selectedObject.transform.position = tempSelectPos;
            selectedObject.SetActive(true);
        }

        //設置モードではない場合
        if (!isSetup)
        {
            CheckXYColumns(selectedcsGC.tilePosition, selectedcsGC.oldTilePosition);

            CheckDeadGhost();

            CheckCorner();

            //ターンの変更と加算を行う
            TurnManage();

        }
        if (isSetup)
        {

            CheckSetUpColumns(GhostController.playArea.WorldToCell(selectedcsGC.startPos), selectedcsGC.tilePosition, selectedGhost);

        }


        CheckWin();

        //バッファの更新
        oldSelectedGhost = selectedGhost;
    }



    private void TurnManage()
    {
        for (int i = 0; i < allGhost.Length; i++)
        {
            GhostController csGC = allGhost[i].GetComponent<GhostController>();

            //このコマが現在のターンと同じIDなら
            if (csGC.playerID == PlayerTurn)
            {
                csGC.SetGhostMask(GhostController.GHOST_MASK.REAL);

                //生存中なら
                if (csGC.alive)
                {
                    //1ターン前に動いているなら
                    if (csGC.tilePosition != csGC.oldTilePosition)
                    {
                        //ターンの入れ替え処理
                        if (PlayerTurn == GhostController.CHECK_PLAYER.PLAYER1)
                            PlayerTurn = GhostController.CHECK_PLAYER.PLAYER2;
                        else
                            PlayerTurn = GhostController.CHECK_PLAYER.PLAYER1;

                        //ターンの加算
                        turnCount++;
                    }
                }
            }
            else
            {
                if (csGC.alive)
                {
                    csGC.SetGhostMask(GhostController.GHOST_MASK.UNKNOWN);
                }
            }

        }
    }

    private void CheckWin()
    {
        //プレイヤー1が負けそうな時
        if (player2EatCount[(int)GhostController.GHOST_IDENTITY.GOOD] == 3 || player1EatCount[(int)GhostController.GHOST_IDENTITY.EVIL] == 3)
        {
            if (soundEffectFlg[(int)SoundEffect.LOSING])
            {
                audioSource.PlayOneShot(SoundEffects[(int)SoundEffect.LOSING]);
                soundEffectFlg[(int)SoundEffect.LOSING] = false;
            }
        }
        //プレイヤー1が勝ちそうな時
        if (player1EatCount[(int)GhostController.GHOST_IDENTITY.GOOD] == 3 || player2EatCount[(int)GhostController.GHOST_IDENTITY.EVIL] == 3)
        {
            if (soundEffectFlg[(int)SoundEffect.WINNING])
            {
                audioSource.PlayOneShot(SoundEffects[(int)SoundEffect.WINNING]);
                soundEffectFlg[(int)SoundEffect.WINNING] = false;
            }

        }


        //プレイヤー1が2の良いお化けを四つ取るまたはプレイヤー2が1の悪いお化けを四つ取る
        if (player2EatCount[(int)GhostController.GHOST_IDENTITY.GOOD] == 4 || player1EatCount[(int)GhostController.GHOST_IDENTITY.EVIL] == 4)
        {

            winState = GhostController.CHECK_PLAYER.PLAYER2;

        }
        //プレイヤー2が1の良いお化けを四つ取るまたはプレイヤー1が2の悪いお化けを四つ取る
        if (player1EatCount[(int)GhostController.GHOST_IDENTITY.GOOD]==4 || player2EatCount[(int)GhostController.GHOST_IDENTITY.EVIL] == 4)
        {

            winState = GhostController.CHECK_PLAYER.PLAYER1;

        }

        //勝敗を判定
        switch (winState)
        {
            case GhostController.CHECK_PLAYER.PLAYER1:

                Debug.Log("Player 1 Win");
                if(soundEffectFlg[(int)SoundEffect.WIN])
                {
                    audioSource.PlayOneShot(SoundEffects[(int)SoundEffect.WIN]);
                    soundEffectFlg[(int)SoundEffect.WIN] = false;
                }
                gameResultImage[0].gameObject.SetActive(true);
                break;

            case GhostController.CHECK_PLAYER.PLAYER2:

                Debug.Log("Player 2 Win");
                if(soundEffectFlg[(int)SoundEffect.LOSE])
                {
                    audioSource.PlayOneShot(SoundEffects[(int)SoundEffect.LOSE]);
                    soundEffectFlg[(int)SoundEffect.LOSE] = false;
                }
                gameResultImage[1].gameObject.SetActive(true);
                break;

            default:
                break;
        }

    }

    private void CheckCorner()
    {
        //現在のターンがプレイヤー1なら
        if (GhostController.CHECK_PLAYER.PLAYER1 == PlayerTurn)
        {
            Debug.Log("isOnCorner[Player 1]:" + isOnCorner[(int)GhostController.CHECK_PLAYER.PLAYER1]);

            //脱出口にコマが乗っている状態が続いているなら
            if (playerTurnCount[(int)GhostController.CHECK_PLAYER.PLAYER1] != 0 && 
                isOnCorner[(int)GhostController.CHECK_PLAYER.PLAYER1] == true)
            {

                GameObject[] buf = GameObject.FindGameObjectsWithTag("Player1CheckPoint");

                for(int i=0;i<allGhost.Length;i++)
                {
                    for(int j =0;j<buf.Length;j++)
                    {
                        //座標変換
                        Vector3Int checkPointPos = GhostController.playArea.WorldToCell(buf[j].transform.position);
                        Vector3Int ghostPos = GhostController.playArea.WorldToCell(allGhost[i].transform.position);

                        if(checkPointPos == ghostPos)
                        {
                            if(allGhost[i].GetComponent<GhostController>().playerID == GhostController.CHECK_PLAYER.PLAYER1)
                                winState = GhostController.CHECK_PLAYER.PLAYER1;
                        }
                    }
                }
            }
            
            //プレイヤー1の良いオバケのコマが相手陣地の脱出口に乗っているなら
            if (isOnCorner[(int)GhostController.CHECK_PLAYER.PLAYER1])
            {
                //現在のターンを保存
                playerTurnCount[(int)GhostController.CHECK_PLAYER.PLAYER1] = turnCount;

            }

        }

        if (GhostController.CHECK_PLAYER.PLAYER2 == PlayerTurn)
        {
            Debug.Log("isOnCorner[Player 2]:" + isOnCorner[(int)GhostController.CHECK_PLAYER.PLAYER2]);

            //脱出口にコマが乗っている状態が続いているなら
            if (playerTurnCount[(int)GhostController.CHECK_PLAYER.PLAYER2] != 0 && 
                isOnCorner[(int)GhostController.CHECK_PLAYER.PLAYER2] == true)
            {
                GameObject[] buf = GameObject.FindGameObjectsWithTag("Player2CheckPoint");

                for (int i = 0; i < allGhost.Length; i++)
                {
                    for (int j = 0; j < buf.Length; j++)
                    {
                        //座標変換
                        Vector3Int checkPointPos = GhostController.playArea.WorldToCell(buf[j].transform.position);
                        Vector3Int ghostPos = GhostController.playArea.WorldToCell(allGhost[i].transform.position);

                        if (checkPointPos == ghostPos)
                        {
                            if (allGhost[i].GetComponent<GhostController>().playerID == GhostController.CHECK_PLAYER.PLAYER2)
                                winState = GhostController.CHECK_PLAYER.PLAYER2;
                        }
                    }
                }
            }

            //プレイヤー2の良いオバケのコマが相手陣地の脱出口に乗っているなら
            if (isOnCorner[(int)GhostController.CHECK_PLAYER.PLAYER2])
            {
                //現在のターンを保存
                playerTurnCount[(int)GhostController.CHECK_PLAYER.PLAYER2] = turnCount;
            }

        }

        for (int i = 0; i < 2; i++) {
            if (isOnCorner[i] == false)
            {
                playerTurnCount[i] = 0;
            }
        }
    }

    private void CheckDeadGhost()
    {
        for (int i = 0; i < allGhost.Length; i++)
        {
            GhostController csGC = allGhost[i].GetComponent<GhostController>();

            //死んでいるなら
            if (csGC.alive == false && csGC.deadProcess == false)
            {
                switch(csGC.playerID)
                {
                    case GhostController.CHECK_PLAYER.PLAYER1:
                        //良いオバケの場合
                        if(csGC.ghostID == GhostController.GHOST_IDENTITY.GOOD)
                        {
                            player2EatCount[(int)GhostController.GHOST_IDENTITY.GOOD]++;
                            //Debug.Log("player2EatCount[Good] : " + player2EatCount[(int)GhostController.GHOST_IDENTITY.GOOD]);
                        }
                        //悪いオバケの場合
                        if(csGC.ghostID == GhostController.GHOST_IDENTITY.EVIL)
                        {
                            player2EatCount[(int)GhostController.GHOST_IDENTITY.EVIL]++;
                            //Debug.Log("player2EatCount[Evil] : " + player2EatCount[(int)GhostController.GHOST_IDENTITY.EVIL]);
                        }
                        MoveDeadPoint(allGhost[i], GhostController.CHECK_PLAYER.PLAYER2);
                        break;

                    case GhostController.CHECK_PLAYER.PLAYER2:
                        //良いオバケの場合
                        if (csGC.ghostID == GhostController.GHOST_IDENTITY.GOOD)
                        {
                            player1EatCount[(int)GhostController.GHOST_IDENTITY.GOOD]++;
                            //Debug.Log("player1EatCount[Good] : " + player1EatCount[(int)GhostController.GHOST_IDENTITY.GOOD]);
                        }
                        //悪いオバケの場合
                        if (csGC.ghostID == GhostController.GHOST_IDENTITY.EVIL)
                        {
                            player1EatCount[(int)GhostController.GHOST_IDENTITY.EVIL]++;
                            //Debug.Log("player1EatCount[Evil] : " + player1EatCount[(int)GhostController.GHOST_IDENTITY.EVIL]);
                        }
                        MoveDeadPoint(allGhost[i], GhostController.CHECK_PLAYER.PLAYER1);
                        break;
                }

                csGC.deadProcess = true;
            }
        }
    }

    private void MoveDeadPoint(GameObject deadGhost , GhostController.CHECK_PLAYER id)
    {
        Vector3 buf = new Vector3(0.0f, 0.0f, 0.0f);
        Vector3 startPoint = deadPoint[(int)id].transform.position;
        Vector3 siftSize = this.GetComponent<GameInit>().tempGridObject.GetComponent<BoxCollider2D>().size;

        int eatCount = 0;

        //プレイヤーごとの食べたゴーストの総数を計算
        if (id == GhostController.CHECK_PLAYER.PLAYER1)
        {
            eatCount =
                 player1EatCount[(int)GhostController.GHOST_IDENTITY.GOOD] +
                 player1EatCount[(int)GhostController.GHOST_IDENTITY.EVIL];
        }
        else
        {
            eatCount =
                 player2EatCount[(int)GhostController.GHOST_IDENTITY.GOOD] +
                 player2EatCount[(int)GhostController.GHOST_IDENTITY.EVIL];
        }

        //位置調整
        if (eatCount < 5)
        {
            buf.x = startPoint.x + (siftSize.x * (eatCount - 1));
            buf.y = startPoint.y;            
        }
        else
        {
            buf.x = startPoint.x + (siftSize.x * (eatCount % 5));
            buf.y = startPoint.y - siftSize.y;
        }

        //変更を反映
        deadGhost.transform.position = buf;

    }


    //移動できるエリア表示
    //通常の移動モード時のタイル表示処理
    public void CheckXYColumns(Vector3Int objectTilePos, Vector3Int oldTilePos)
    {
        Vector3Int xStartPoint = new Vector3Int(objectTilePos.x - 1, objectTilePos.y, objectTilePos.z);
        Vector3Int yStartPoint = new Vector3Int(objectTilePos.x, objectTilePos.y + 1, objectTilePos.z);
        Vector3Int buf;

        for (int x = 0; x < 3; x++)
        {
            //エリアの非表示処理
            if (selectedcsGC.isSelected == false && 
                selectedcsGC.oldIsSelected == true)
            {
                buf = new Vector3Int(oldTilePos.x + x - 1, oldTilePos.y, oldTilePos.z);

                GhostController.playArea.SetTileFlags(buf, TileFlags.None);
                GhostController.playArea.SetColor(buf, new Color(tileColor.r, tileColor.g, tileColor.b, 0.3f));
                GhostController.playArea.SetTileFlags(buf, TileFlags.LockColor);

                if (x == 3)
                    selectedcsGC.oldIsSelected = false;
            }

            //エリアの表示処理
            if (selectedcsGC.isSelected == true && selectedcsGC.oldIsSelected == true)
            {
                buf = new Vector3Int(xStartPoint.x + x, xStartPoint.y, xStartPoint.z);
                bool exist = false;
                GhostController checkcsGC = null;

                //コマが検索位置にあるかどうかを判定する処理
                for (int i =0;i<allGhost.Length;i++)
                {
                    checkcsGC = allGhost[i].GetComponent<GhostController>();

                    //オブジェクトがそのマスにある場合
                    if(checkcsGC.tilePosition == buf)
                    {
                        exist = true;
                        break;
                    }
                }

                //コマが自身ではない　かつ　(オブジェクトがない または　(オブジェクトがある かつ IDが違うなら))
                if (buf != selectedcsGC.tilePosition &&
                    (exist == false ||
                    (exist && checkcsGC.playerID != selectedcsGC.playerID)))
                {
                    //Get the start point (started from the left side of the player)
                    GhostController.playArea.SetTileFlags(buf, TileFlags.None);
                    GhostController.playArea.SetColor(buf, tileColor);
                    GhostController.playArea.SetTileFlags(buf, TileFlags.LockColor);
                }
            }
        }

        for (int y = 0; y < 3; y++)
        {
            if (selectedcsGC.isSelected == false && selectedcsGC.oldIsSelected == true)
            {
                buf = new Vector3Int(oldTilePos.x, oldTilePos.y - y + 1, oldTilePos.z);

                GhostController.playArea.SetTileFlags(buf, TileFlags.None);
                GhostController.playArea.SetColor(buf, new Color(tileColor.r, tileColor.g, tileColor.b, 0.3f));
                GhostController.playArea.SetTileFlags(buf, TileFlags.LockColor);

                if (y == 3)
                    selectedcsGC.oldIsSelected = false;
            }

            if (selectedcsGC.isSelected == true && selectedcsGC.oldIsSelected == true)
            {
                buf = new Vector3Int(yStartPoint.x, yStartPoint.y - y, yStartPoint.z);
                bool exist = false;
                GhostController checkcsGC = null;

                //コマが検索位置にあるかどうかを判定する処理
                for (int i = 0; i < allGhost.Length; i++)
                {
                    checkcsGC = allGhost[i].GetComponent<GhostController>();

                    //オブジェクトがそのマスにある場合
                    if (checkcsGC.tilePosition == buf)
                    {
                        exist = true;
                        break;
                    }
                }

                //コマが自身ではない　かつ　(オブジェクトがない または　(オブジェクトがある かつ IDが違うなら))
                if (buf != selectedcsGC.tilePosition &&
                    (exist == false ||
                    (exist && checkcsGC.playerID != selectedcsGC.playerID)))
                {
                    //Get the start point (started from the left side of the player)
                    GhostController.playArea.SetTileFlags(buf, TileFlags.None);
                    GhostController.playArea.SetColor(buf, tileColor);
                    GhostController.playArea.SetTileFlags(buf, TileFlags.LockColor);
                }
            }

        }

    }

    //設置モード時のタイル表示処理
    private void CheckSetUpColumns(Vector3Int startPos, Vector3Int originTilePos,GameObject gameObject)
    {
        Vector3Int startPoint = startPos;

        GhostController csGC = gameObject.GetComponent<GhostController>();

        for (int y = 0; y < 2; y++)
        {

            for (int x = 0; x < 4; x++)
            {

                Vector3Int tempStartPoint = new Vector3Int(startPoint.x + x, startPoint.y - y, startPoint.z);

                if (csGC.isSelected == false/* && csGC.playerID!=PlayerTurn*/)
                {
                    GhostController.playArea.SetTileFlags(tempStartPoint, TileFlags.None);
                    //Set the colour.
                    GhostController.playArea.SetColor(tempStartPoint, new Color(tileColor.r, tileColor.g, tileColor.b, 0.3f));

                }

                if (csGC.isSelected == true/* && csGC.playerID == PlayerTurn*/)
                {

                    if (tempStartPoint != originTilePos)
                    {
                        GhostController.playArea.SetTileFlags(tempStartPoint, TileFlags.None);
                        //Set the colour.
                        GhostController.playArea.SetColor(tempStartPoint, tileColor);

                    }
                }

            }

        }


    }

    private void RefreshTileColor()
    {
        Vector3Int startPos = GhostController.playArea.WorldToCell(refreshStartPoint.transform.position);
        Vector3Int buf;

        for(int y =0;y<6;y++)
        {
            for(int x=0;x<6;x++)
            {
                buf = new Vector3Int(startPos.x + x, startPos.y - y, startPos.z);

                GhostController.playArea.SetTileFlags(buf, TileFlags.None);
                GhostController.playArea.SetColor(buf, new Color(tileColor.r, tileColor.g, tileColor.b, 0.3f));
                GhostController.playArea.SetTileFlags(buf, TileFlags.LockColor);

            }
        }
    }

}
