using System.Collections;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Security.Cryptography.X509Certificates;
using UnityEngine;
using UnityEngine.Networking.NetworkSystem;
using UnityEngine.Tilemaps;

//プレイヤーの位置をセットするスクリプト
public class GameInit : MonoBehaviour
{
    public static Vector3 Player1StartPos;
    public static Vector3 Player2StartPos;

   [Tooltip("初期化するオブジェクトを格納 (GameObject[])")]
    public GameObject goodGhost;
    public GameObject badGhost;

    public GameObject tempGridObject;

    [Tooltip("タイルマップを格納する")]
    public Tilemap setArea;

    [Tooltip("縦横のずらす値の大きさ (Vector3)")]
    private Vector3 siftSize;

    [Tooltip("マス目の分割数 (Vector2)")]
    static public Vector2 split = new Vector2(4, 2);

    private static string PlayerName;
    private static GhostController.CHECK_PLAYER id;
    private static Vector3 bufPos;

    // Start is called before the first frame update
    void Awake()
    {

        siftSize = tempGridObject.GetComponent<BoxCollider2D>().size;

        Player1StartPos = transform.GetChild(0).gameObject.transform.position;
        Player2StartPos = transform.GetChild(1).gameObject.transform.position;

        for (int i = 0; i < 2; i++)
        {
            //プレイヤー1の初期配置座標を取得
            Vector3 startPos;

            switch (i)
            {

                case 0:
                    startPos = Player1StartPos;
                    PlayerName = "Player1";
                    id = GhostController.CHECK_PLAYER.PLAYER1;
                    for (int y = 0; y < split.y; y++)
                    {
                        //Y軸をずらす
                        bufPos.y = -(y * siftSize.y) + startPos.y;

                        for (int x = 0; x < split.x; x++)
                        {
                            //X軸をずらす
                            bufPos.x = x * siftSize.x + startPos.x;

                            //お化けのオブジェクトを作成
                            if (y == 0)
                            {

                                //良いお化けのオブジェクト作成
                                GameObject buf = Instantiate(goodGhost, bufPos, Quaternion.identity);

                                buf.name = PlayerName + "gGhost" + x.ToString();
                                buf.GetComponent<GhostController>().playerID = id;
                                buf.GetComponent<GhostController>().ghostID = GhostController.GHOST_IDENTITY.GOOD;
                                //プレイヤーごとに必要な初期座標を格納
                                buf.GetComponent<GhostController>().startPos = startPos;

                                buf.GetComponent<GhostController>().tilePosition = setArea.WorldToCell(buf.transform.position);
                                buf.transform.position = setArea.CellToWorld(buf.GetComponent<GhostController>().tilePosition);

                            }
                            else
                            {

                                //悪いお化けのオブジェクト作成
                                GameObject buf = Instantiate(badGhost, bufPos, Quaternion.identity);

                                buf.name = PlayerName + "bGhost" + x.ToString();
                                buf.GetComponent<GhostController>().playerID = id;
                                buf.GetComponent<GhostController>().ghostID = GhostController.GHOST_IDENTITY.EVIL;
                                //プレイヤーごとに必要な初期座標を格納
                                buf.GetComponent<GhostController>().startPos = startPos;

                                buf.GetComponent<GhostController>().tilePosition = setArea.WorldToCell(buf.transform.position);
                                buf.transform.position = setArea.CellToWorld(buf.GetComponent<GhostController>().tilePosition);
                            }

                        }

                    }
                    break;

                case 1:
                    startPos = Player2StartPos;
                    PlayerName = "Player2";
                    id = GhostController.CHECK_PLAYER.PLAYER2;
                    for (int y = 0; y < split.y; y++)
                    {
                        //Y軸をずらす
                        bufPos.y = -(y * siftSize.y) + startPos.y;

                        for (int x = 0; x < split.x; x++)
                        {
                            //X軸をずらす
                            bufPos.x = x * siftSize.x + startPos.x;

                            //お化けのオブジェクトを作成
                            if (y == 0)
                            {

                                //悪いお化けのオブジェクト作成
                                GameObject buf = Instantiate(badGhost, bufPos, Quaternion.identity);
                                buf.name = PlayerName + "bGhost" + x.ToString();
                                buf.GetComponent<GhostController>().playerID = id;
                                buf.GetComponent<GhostController>().ghostID = GhostController.GHOST_IDENTITY.EVIL;
                                //プレイヤーごとに必要な初期座標を格納
                                buf.GetComponent<GhostController>().startPos = startPos;

                                buf.GetComponent<GhostController>().tilePosition = setArea.WorldToCell(buf.transform.position);
                                buf.transform.position = setArea.CellToWorld(buf.GetComponent<GhostController>().tilePosition);
                            }
                            else
                            {
                                //良いお化けのオブジェクト作成
                                GameObject buf = Instantiate(goodGhost, bufPos, Quaternion.identity);
                                buf.name = PlayerName + "gGhost" + x.ToString();
                                buf.GetComponent<GhostController>().playerID = id;
                                buf.GetComponent<GhostController>().ghostID = GhostController.GHOST_IDENTITY.GOOD;
                                //プレイヤーごとに必要な初期座標を格納
                                buf.GetComponent<GhostController>().startPos = startPos;

                                buf.GetComponent<GhostController>().tilePosition = setArea.WorldToCell(buf.transform.position);
                                buf.transform.position = setArea.CellToWorld(buf.GetComponent<GhostController>().tilePosition);
                            }

                        }

                    }

                    break;
            }

        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
