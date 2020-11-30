using Protocol;
using UnityEngine;
using UnityEngine.Events;

namespace HTTP
{
    public class ApiClient : MonoBehaviour
    {
        private static ApiClient instance;
        private        string    ipAddr;

        private HTTPRequester requester;

        /// <summary>
        ///     ResponseCreatePlayerEntry
        ///     /api/rooms/:room_id/player_entriesへPOSTでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseCreatePlayerEntry> ResponseCreatePlayerEntry;

        /// <summary>
        ///     ResponseCreateRoom
        ///     /api/roomsへPOSTでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseCreateRoom> ResponseCreateRoom;

        /// <summary>
        ///     ResponseCreateSpectatorEntry
        ///     /api/rooms/:room_id/spectator_entriesへPOSTでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseCreateSpectatorEntry> ResponseCreateSpectatorEntry;

        /// <summary>
        ///     ResponseCreateUser
        ///     /api/usersへPOSTでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseCreateUser> ResponseCreateUser;

        /// <summary>
        ///     ResponseCreateUserSession
        ///     /api/user_sessionsへPOSTでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseCreateUserSession> ResponseCreateUserSession;

        /// <summary>
        ///     ResponseDeletePlayerEntry
        ///     /api/player_entries/:player_entry_idへDELETEでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseDeletePlayerEntry> ResponseDeletePlayerEntry;

        /// <summary>
        ///     ResponseDeleteSpectatorEntry
        ///     /api/spectator_entries/:spectator_entry_idへDELETEでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseDeleteSpectatorEntry> ResponseDeleteSpectatorEntry;

        /// <summary>
        ///     ResponseDeleteUserSession
        ///     /api/user_sessions/:user_session_idへDELETEでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseDeleteUserSession> ResponseDeleteUserSession;

        /// <summary>
        ///     ResponseListPieces
        ///     /api/games/:game_id/piecesへGETでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseListPieces> ResponseListPieces;

        /// <summary>
        ///     ResponseListRooms
        ///     /api/roomsへGETでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseListRooms> ResponseListRooms;

        /// <summary>
        ///     ResponsePrepareGame
        ///     /api/games/:game_id/preparationへPOSTでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponsePrepareGame> ResponsePrepareGame;

        /// <summary>
        ///     ResponseShowGame
        ///     /api/games/:game_idへGETでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseShowGame> ResponseShowGame;

        /// <summary>
        ///     ResponseShowPiece
        ///     /api/pieces/:piece_idへGETでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseShowPiece> ResponseShowPiece;

        /// <summary>
        ///     ResponseShowRoom
        ///     /api/rooms/:room_idへGETでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseShowRoom> ResponseShowRoom;

        /// <summary>
        ///     ResponseShowUser
        ///     /api/users/:user_idへGETでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseShowUser> ResponseShowUser;

        /// <summary>
        ///     ResponseUpdatePiece
        ///     /api/pieces/:piece_idへPUTでリクエストを行った時のコールバックを登録する
        /// </summary>
        public UnityAction<ResponseUpdatePiece> ResponseUpdatePiece;

        private ApiClient()
        {
        }

        public static ApiClient Instance
        {
            get
            {
                if (instance == null)
                {
                    var go = new GameObject("ApiClient");
                    instance = go.AddComponent<ApiClient>();
                }

                return instance;
            }
        }

        public void SetAccessToken(string token)
        {
            requester.SetAccessToken(token);
        }

        public void SetIpAddress(string ipAddress)
        {
            ipAddr = ipAddress;
        }

        private void Awake()
        {
            requester = new HTTPRequester(this);
            DontDestroyOnLoad(this);
        }

        /// <summary>
        ///     RequestShowUser
        ///     /api/users/:user_idへGETでリクエストを行なう
        /// </summary>
        public void RequestShowUser(RequestShowUser param)
        {
            var url = ipAddr + string.Format("/api/users/{0}", param.user_id);
            requester.Get(url, ResponseShowUser);
        }

        /// <summary>
        ///     RequestCreateUser
        ///     /api/usersへPOSTでリクエストを行なう
        /// </summary>
        public void RequestCreateUser(RequestCreateUser param)
        {
            var url = ipAddr + "/api/users";
            requester.Post(url, param, ResponseCreateUser);
        }

        /// <summary>
        ///     RequestCreateUserSession
        ///     /api/user_sessionsへPOSTでリクエストを行なう
        /// </summary>
        public void RequestCreateUserSession(RequestCreateUserSession param)
        {
            var url = ipAddr + "/api/user_sessions";
            requester.Post(url, param, ResponseCreateUserSession);
        }

        /// <summary>
        ///     RequestDeleteUserSession
        ///     /api/user_sessions/:user_session_idへDELETEでリクエストを行なう
        /// </summary>
        public void RequestDeleteUserSession(RequestDeleteUserSession param)
        {
            var url = ipAddr + string.Format("/api/user_sessions/{0}", param.user_session_id);
            requester.Delete(url, param, ResponseDeleteUserSession);
        }

        /// <summary>
        ///     RequestShowRoom
        ///     /api/rooms/:room_idへGETでリクエストを行なう
        /// </summary>
        public void RequestShowRoom(RequestShowRoom param)
        {
            var url = ipAddr + string.Format("/api/rooms/{0}", param.room_id);
            requester.Get(url, ResponseShowRoom);
        }

        /// <summary>
        ///     RequestCreateRoom
        ///     /api/roomsへPOSTでリクエストを行なう
        /// </summary>
        public void RequestCreateRoom(RequestCreateRoom param)
        {
            var url = ipAddr + "/api/rooms";
            requester.Post(url, param, ResponseCreateRoom);
        }

        /// <summary>
        ///     RequestListRooms
        ///     /api/roomsへGETでリクエストを行なう
        /// </summary>
        public void RequestListRooms(RequestListRooms param)
        {
            var url = ipAddr + "/api/rooms";
            requester.Get(url, ResponseListRooms);
        }

        /// <summary>
        ///     RequestCreatePlayerEntry
        ///     /api/rooms/:room_id/player_entriesへPOSTでリクエストを行なう
        /// </summary>
        public void RequestCreatePlayerEntry(RequestCreatePlayerEntry param)
        {
            var url = ipAddr + string.Format("/api/rooms/{0}/player_entries", param.room_id);
            requester.Post(url, param, ResponseCreatePlayerEntry);
        }

        /// <summary>
        ///     RequestDeletePlayerEntry
        ///     /api/player_entries/:player_entry_idへDELETEでリクエストを行なう
        /// </summary>
        public void RequestDeletePlayerEntry(RequestDeletePlayerEntry param)
        {
            var url = ipAddr + string.Format("/api/player_entries/{0}", param.player_entry_id);
            requester.Delete(url, param, ResponseDeletePlayerEntry);
        }

        /// <summary>
        ///     RequestCreateSpectatorEntry
        ///     /api/rooms/:room_id/spectator_entriesへPOSTでリクエストを行なう
        /// </summary>
        public void RequestCreateSpectatorEntry(RequestCreateSpectatorEntry param)
        {
            var url = ipAddr + string.Format("/api/rooms/{0}/spectator_entries", param.room_id);
            requester.Post(url, param, ResponseCreateSpectatorEntry);
        }

        /// <summary>
        ///     RequestDeleteSpectatorEntry
        ///     /api/spectator_entries/:spectator_entry_idへDELETEでリクエストを行なう
        /// </summary>
        public void RequestDeleteSpectatorEntry(RequestDeleteSpectatorEntry param)
        {
            var url = ipAddr + string.Format("/api/spectator_entries/{0}", param.spectator_entry_id);
            requester.Delete(url, param, ResponseDeleteSpectatorEntry);
        }

        /// <summary>
        ///     RequestShowGame
        ///     /api/games/:game_idへGETでリクエストを行なう
        /// </summary>
        public void RequestShowGame(RequestShowGame param)
        {
            var url = ipAddr + string.Format("/api/games/{0}", param.game_id);
            requester.Get(url, ResponseShowGame);
        }

        /// <summary>
        ///     RequestPrepareGame
        ///     /api/games/:game_id/preparationへPOSTでリクエストを行なう
        /// </summary>
        public void RequestPrepareGame(RequestPrepareGame param)
        {
            var url = ipAddr + string.Format("/api/games/{0}/preparation", param.game_id);
            requester.Post(url, param, ResponsePrepareGame);
        }

        /// <summary>
        ///     RequestListPieces
        ///     /api/games/:game_id/piecesへGETでリクエストを行なう
        /// </summary>
        public void RequestListPieces(RequestListPieces param)
        {
            var url = ipAddr + string.Format("/api/games/{0}/pieces", param.game_id);
            requester.Get(url, ResponseListPieces);
        }

        /// <summary>
        ///     RequestShowPiece
        ///     /api/pieces/:piece_idへGETでリクエストを行なう
        /// </summary>
        public void RequestShowPiece(RequestShowPiece param)
        {
            var url = ipAddr + string.Format("/api/pieces/{0}", param.piece_id);
            requester.Get(url, ResponseShowPiece);
        }

        /// <summary>
        ///     RequestUpdatePiece
        ///     /api/pieces/:piece_idへPUTでリクエストを行なう
        /// </summary>
        public void RequestUpdatePiece(RequestUpdatePiece param)
        {
            var url = ipAddr + string.Format("/api/pieces/{0}", param.piece_id);
            requester.Put(url, param, ResponseUpdatePiece);
        }
    }
}