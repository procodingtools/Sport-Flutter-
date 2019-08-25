class WebService {
  static final String BASE_URL = "http://192.168.100.76:8000/",
      ACTIVITY = BASE_URL + "Server/Activite/",
      PHOTOS = "http://192.168.100.76/Temp/",
      RESERVED = BASE_URL + "Server/GetReservation/",
      RESUME = BASE_URL + "Server/Planning/",
      NEWS = BASE_URL + "Server/Actualite/",
      COACHES = BASE_URL + "Server/Coach/",
      RESERVE_COACH = BASE_URL + "Server/AddReservationCoach/",//+userId
      RESERVED_COACHS = BASE_URL + "Server/Reservationcoach/",// +userId
      DELETE_COACH_RESERVATION = BASE_URL + '/Server/DeleteReservationCoach/',//+id reservation
      LOGIN = BASE_URL + "Server/Login",
      RESERVE = BASE_URL + "Server/AddReservation/",
      DELETE_RESERVATION = BASE_URL + "Server/DeleteReservation/",
      PRICING = BASE_URL + "Server/typeAbonnement/",
      MEMBERSHIPS = BASE_URL + "Server/getabonnement/",//+idUser
      SIGNUP = BASE_URL + "Server/signup/",
      ADD_RATING = BASE_URL + "Server/Addrating",
      UPDATE_RATING = BASE_URL + "Server/updateRating",
      MEMBERSHIP_TYPE = BASE_URL + "Server/getbytypeabonnement/"; //+idMembership
}
