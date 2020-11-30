using System.Collections;
using System.Collections.Generic;
using System.Diagnostics.Tracing;
using System.Runtime.CompilerServices;
using UnityEngine;
using UnityEngine.Tilemaps;
using UnityEngine.UI;

public class GhostController : MonoBehaviour
{
    public enum CHECK_PLAYER
    {
        PLAYER1,
        PLAYER2,
        NONE
    }

    public enum GHOST_IDENTITY{

        GOOD,
        EVIL
    }

    public enum GHOST_MASK
    {
        UNKNOWN,
        REAL
    }


    public static Tilemap playArea;


    [Tooltip("ゴーストを認知するためのレイヤーマスク")]
    public LayerMask GhostLayerMask;

    [Tooltip("このコマの所有者ID")]
    public CHECK_PLAYER playerID;

    [Tooltip("このコマのお化け種類")]
    public GHOST_IDENTITY ghostID;

    [Tooltip("このコマのお化けマスク")]
    public GHOST_MASK ghostMask;

    [Tooltip("生存しているかどうか (bool)")]
    public bool alive;
    public bool deadProcess;

    [Tooltip("位置座標を格納 (Vector3Int)")]
    public Vector3Int tilePosition;

    [Tooltip("1ターン前の位置座標を格納 (Vector3Int)")]
    public Vector3Int oldTilePosition;

    [Tooltip("設置モードの完了を管理するボタンを格納 (Button)")]
    public Button[] setupReadyButton;

    [SerializeField]
    public bool isSelected;

    [SerializeField]
    public bool oldIsSelected;

    [SerializeField]
    private bool isMove;

    [SerializeField]
    private bool isClicked;

    [SerializeField]
    private float tilemapSize = 1.0f;

    [SerializeField]
    private int saveTurnCount;

    public Sprite unknownMask, realMask;

    public Vector3 startPos;

    private GameObject board;
    private AudioSource boardAudio;
    private GameController csGameController;



    // Start is called before the first frame update
    void Awake()
    {
        board = GameObject.Find("board");
        boardAudio = board.GetComponent<AudioSource>();
        csGameController = board.GetComponent<GameController>();

        playArea = GameObject.Find("MoveArea").GetComponent<Tilemap>();


        tilePosition = playArea.WorldToCell(this.transform.position);
        oldTilePosition = tilePosition;
        alive = true;
        deadProcess = false;

        isSelected = false;
        oldIsSelected = false;
        isMove = false;
        isClicked = false;
        saveTurnCount = 1;
    }

    // Update is called once per frame
    void Update()
    {
        //ターンが変わっていたら
        if (saveTurnCount != GameController.turnCount)
        {
            //位置座標を格納
            oldTilePosition = tilePosition;
        }

        //初期配置モードの動作
        if (GameController.isSetup)
        {
            SetUpPhase(startPos);
        }

        if(GameController.isSetup == false)
        {
            //移動可能なタイルを表示
            //CheckXYColumns(playArea.WorldToCell(this.transform.position),oldTilePosition);

            //プレイヤーのターン処理
            if (GameController.PlayerTurn == playerID)
            {
                //通常モードの動作
                Movement();
            }
        }

        //ターンが変わっていたら
        if (saveTurnCount != GameController.turnCount)
        {
            saveTurnCount = GameController.turnCount;
        }
    }

    public void MoveCoin(Vector3Int newTilePostion)
    {

        //ボード外に出ていないかつ同じIDのコマがない場合
        if (playArea.HasTile(newTilePostion))
        {
            tilePosition = newTilePostion;
            this.transform.position = playArea.CellToWorld(tilePosition);
        }

    }

    ////通常の移動モード時のタイル表示処理
    //public void CheckXYColumns(Vector3Int objectTilePos,Vector3Int oldTilePos)
    //{
    //    Vector3Int xStartPoint = new Vector3Int(objectTilePos.x - 1, objectTilePos.y, objectTilePos.z);
    //    Vector3Int yStartPoint = new Vector3Int(objectTilePos.x, objectTilePos.y + 1, objectTilePos.z);
    //    Vector3Int buf;

    //    for (int x = 0; x < 3; x++)
    //    {
    //        if (isSelected == false && oldIsSelected == true)
    //        {
    //            buf = new Vector3Int(oldTilePos.x + x - 1, oldTilePos.y, oldTilePos.z);

    //            playArea.SetTileFlags(buf, TileFlags.None);
    //            playArea.SetColor(buf, new Color(tileColor.r, tileColor.g, tileColor.b, 0.3f));
    //            playArea.SetTileFlags(buf, TileFlags.LockColor);

    //            if (x == 3)
    //                oldIsSelected = false;
    //        }

    //        if (isSelected == true && oldIsSelected == true)
    //        {
    //            buf = new Vector3Int(xStartPoint.x + x, xStartPoint.y, xStartPoint.z);

    //            //Get the start point (started from the left side of the player)
    //            playArea.SetTileFlags(buf, TileFlags.None);
    //            playArea.SetColor(buf, tileColor);
    //            playArea.SetTileFlags(buf, TileFlags.LockColor);
    //            Debug.Log("x : "+ x +"  PlayArea Color : " + playArea.GetColor(buf));
    //        }
            
    //    }

    //    for(int y = 0; y < 3; y++)
    //    {

    //        if (isSelected == false && oldIsSelected == true)
    //        {
    //            buf = new Vector3Int(oldTilePos.x, oldTilePos.y - y + 1, oldTilePos.z);

    //            playArea.SetTileFlags(buf, TileFlags.None);
    //            playArea.SetColor(buf, new Color(tileColor.r, tileColor.g, tileColor.b, 0.3f));
    //            playArea.SetTileFlags(buf, TileFlags.LockColor);

    //            if (y == 3)
    //                oldIsSelected = false;
    //        }

    //        if (isSelected == true && oldIsSelected == true)
    //        {
    //            buf = new Vector3Int(yStartPoint.x, yStartPoint.y - y, yStartPoint.z);

    //            playArea.SetTileFlags(buf, TileFlags.None);
    //            playArea.SetColor(buf, tileColor);
    //            playArea.SetTileFlags(buf, TileFlags.LockColor);
    //            Debug.Log("y : " + y + "  PlayArea Color : " + playArea.GetColor(buf));

    //        }

    //    }

    //}

    ////設置モード時のタイル表示処理
    //private void CheckSetUpColumns(Vector3Int startPos,Vector3Int originTilePos)
    //{
    //    Vector3Int startPoint = startPos;

    //    for (int y = 0; y < 2; y++)
    //    {

    //        for(int x = 0; x < 4; x++)
    //        {

    //            Vector3Int tempStartPoint = new Vector3Int(startPoint.x + x, startPoint.y - y, startPoint.z);

    //            if (tempStartPoint != originTilePos)
    //            {
    //                playArea.SetTileFlags(tempStartPoint, TileFlags.None);
    //                //Set the colour.
    //                playArea.SetColor(tempStartPoint, tileColor);

    //            }

    //        }

    //    }


    //}



    private GameObject FindGhost(Vector3 SearchPoint)
    {

        RaycastHit2D hit = 
            Physics2D.Raycast(
                SearchPoint, 
                new Vector2(0,0), 
                1.0f,
                GhostLayerMask, 
                0,  //minDepth
                1   //maxDepth
                );

        //Debug.Log("hit : " + hit.collider);

        //指定されたレイヤーのオブジェクトに当たった場合
        if (hit.collider)
        {
            //Debug.Log("hit : " + hit.collider.gameObject);
            //Debug.Log("id : " + hit.collider.GetComponent<GhostController>().playerID);
            //当たったオブジェクトのIDが同じものなら
            if (playerID == hit.collider.GetComponent<GhostController>().playerID)
            {
                return hit.collider.gameObject;
            }
        }

        return null;
    }

    private void SetUpPhase(Vector3 StartPosition)
    {

        this.isClicked = Input.GetMouseButtonDown(0);

        if (this.isSelected)
        {

            ////移動可能なタイルを表示
            Vector3Int startTilePoint = playArea.WorldToCell(StartPosition);

            //CheckSetUpColumns(startTilePoint, tilePosition);

            if (isClicked)
            {
                //Debug.Log("is Selected ?" + isSelected);

                Vector3 tempMousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                Vector3Int mouseTilePos = playArea.WorldToCell(tempMousePos);

                //マウス位置にコマが存在しているか判定
                GameObject buf = FindGhost(tempMousePos);

                //存在しているなら
                if (buf != null && this.playerID==buf.GetComponent<GhostController>().playerID)
                {
                    //それぞれの位置をタイルマップ用に変換
                    Vector3Int selectCoin1 = playArea.WorldToCell(this.transform.position);
                    Vector3Int selectCoin2 = playArea.WorldToCell(buf.transform.position);

                    //入れ替え処理
                    MoveCoin(selectCoin2);
                    buf.GetComponent<GhostController>().MoveCoin(selectCoin1);

                    this.isClicked = false;
                    this.isSelected = false;

                }
            }
        }

        if (this.isClicked)
        {

            //Mouse Position to Tilemap Position
            Vector3 mousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
            Vector3Int mouseTilePos = playArea.WorldToCell(mousePos);

            if (mouseTilePos == tilePosition)
            {
                this.isSelected = true;
            }

        }

        //Player Position Conversion
        tilePosition = playArea.WorldToCell(this.transform.position);

    }


    private void Movement()
    {
        //生存しているなら
        if(alive)
        {
            isClicked = Input.GetMouseButtonDown(0);

            //Check the coodinates coin that can go to
            if (isSelected)
            {

                if (Input.GetMouseButtonDown(0))
                {
                    Vector3 tempMousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                    Vector3Int mouseTilePos = playArea.WorldToCell(tempMousePos);
                    GameObject buf = FindGhost(tempMousePos);
                    
                    //自身の縦横1マス以内 かつ 仲間のコマがいないなら
                    if (Vector3Int.Distance(this.tilePosition, mouseTilePos) <= tilemapSize &&
                        buf == null)
                    {
                    
                        MoveCoin(mouseTilePos);

                        int seNom = Random.Range(0, 2);
                        switch(seNom)
                        {
                            case 0:
                                if (csGameController.soundEffectFlg[(int)GameController.SoundEffect.ISMOVE_1])
                                {
                                    boardAudio.PlayOneShot(csGameController.SoundEffects[(int)GameController.SoundEffect.ISMOVE_1]);
                                    csGameController.soundEffectFlg[(int)GameController.SoundEffect.ISMOVE_1] = false;
                                }
                                break;

                            case 1:
                                if (csGameController.soundEffectFlg[(int)GameController.SoundEffect.ISMOVE_2])
                                {
                                    boardAudio.PlayOneShot(csGameController.SoundEffects[(int)GameController.SoundEffect.ISMOVE_2]);
                                    csGameController.soundEffectFlg[(int)GameController.SoundEffect.ISMOVE_2] = false;
                                }
                                break;

                            default:
                                break;
                        }
                    }
                    isClicked = false;
                    isSelected = false;
                    csGameController.soundEffectFlg[(int)GameController.SoundEffect.SELECT] = true;
                    csGameController.soundEffectFlg[(int)GameController.SoundEffect.ISMOVE_1] = true;
                    csGameController.soundEffectFlg[(int)GameController.SoundEffect.ISMOVE_2] = true;
                }

            }


            if (isClicked)
            {

                //Mouse Position to Tilemap Position
                Vector3 mousePos = Camera.main.ScreenToWorldPoint(Input.mousePosition);
                Vector3Int mouseTilePos = playArea.WorldToCell(mousePos);

                if (mouseTilePos == tilePosition)
                {
                    this.isSelected = true;
                    this.oldIsSelected = true;

                    if(csGameController.soundEffectFlg[(int)GameController.SoundEffect.SELECT])
                    {
                        boardAudio.PlayOneShot(csGameController.SoundEffects[(int)GameController.SoundEffect.SELECT]);
                        csGameController.soundEffectFlg[(int)GameController.SoundEffect.SELECT] = false;
                    }
                }

            }

            //Player Position Conversion
            tilePosition = playArea.WorldToCell(this.transform.position);
        }
    }


    private void OnTriggerEnter2D(Collider2D collision)
    {

        //Debug.Log("Enter CheckPoint");

        switch (playerID)
        {

            case CHECK_PLAYER.PLAYER1:
                //相手のコマとの当たり判定
                if(collision.gameObject.CompareTag("Ghost") && 
                   playerID != collision.gameObject.GetComponent<GhostController>().playerID &&
                   playerID != GameController.PlayerTurn)
                {
                    EatGhost(collision.gameObject);
                }



                //四隅の脱出ポイントとの当たり判定
                if (collision.gameObject.CompareTag("Player1CheckPoint") && ghostID == GHOST_IDENTITY.GOOD)
                {
                    GameController.isOnCorner[(int)CHECK_PLAYER.PLAYER1] = true;
                }
                break;

            case CHECK_PLAYER.PLAYER2:
                //相手のコマとの当たり判定
                if (collision.gameObject.CompareTag("Ghost") && 
                    playerID != collision.gameObject.GetComponent<GhostController>().playerID &&
                    playerID != GameController.PlayerTurn)
                {
                    EatGhost(collision.gameObject);
                }

                //四隅の脱出ポイントとの当たり判定
                if (collision.gameObject.CompareTag("Player2CheckPoint") && ghostID == GHOST_IDENTITY.GOOD)
                {

                    GameController.isOnCorner[(int)CHECK_PLAYER.PLAYER2] = true;
                }
                break;
        }

    }

    private void OnTriggerExit2D(Collider2D collision)
    {
        switch (playerID)
        {

            case CHECK_PLAYER.PLAYER1:
                //四隅の脱出ポイントとの当たり判定
                if (collision.gameObject.CompareTag("Player1CheckPoint") && ghostID == GHOST_IDENTITY.GOOD)
                {
                    GameController.isOnCorner[(int)CHECK_PLAYER.PLAYER1] = false;
                    //Debug.Log("Player 1 Exit");
                }
                break;

            case CHECK_PLAYER.PLAYER2:
                //四隅の脱出ポイントとの当たり判定
                if (collision.gameObject.CompareTag("Player2CheckPoint") && ghostID == GHOST_IDENTITY.GOOD)
                {

                    GameController.isOnCorner[(int)CHECK_PLAYER.PLAYER2] = false;
                    //Debug.Log("Player 2 Exit");
                }
                break;
        }
    }

    private void EatGhost(GameObject eatTarget)
    {
        eatTarget.GetComponent<GhostController>().alive = false;   
        
        switch(eatTarget.GetComponent<GhostController>().ghostID)
        {
            case GHOST_IDENTITY.GOOD:
                //if (csGameController.soundEffectFlg[(int)GameController.SoundEffect.GOODGHOST_EAT])
                //{
                //    boardAudio.PlayOneShot(csGameController.SoundEffects[(int)GameController.SoundEffect.GOODGHOST_EAT]);
                //    csGameController.soundEffectFlg[(int)GameController.SoundEffect.GOODGHOST_EAT] = false;
                //}

                //boardAudio.PlayOneShot(csGameController.SoundEffects[(int)GameController.SoundEffect.GOODGHOST_EAT]);
                break;

            case GHOST_IDENTITY.EVIL:
                //if (csGameController.soundEffectFlg[(int)GameController.SoundEffect.BADGHOST_EAT])
                //{
                //    boardAudio.PlayOneShot(csGameController.SoundEffects[(int)GameController.SoundEffect.BADGHOST_EAT]);
                //    csGameController.soundEffectFlg[(int)GameController.SoundEffect.BADGHOST_EAT] = false;
                //}

                //boardAudio.PlayOneShot(csGameController.SoundEffects[(int)GameController.SoundEffect.BADGHOST_EAT]);
                break;

            default:
                break;
        }
    }


    public void SetGhostMask(GHOST_MASK checkMask)
    {
        switch (checkMask)
        {
            case GHOST_MASK.UNKNOWN:

                this.GetComponent<SpriteRenderer>().sprite = this.unknownMask;
                break;

            case GHOST_MASK.REAL:

                this.GetComponent<SpriteRenderer>().sprite = this.realMask;
                break;
        }
    }
}
