package server;

import java.util.ArrayList;

public class GameManager {
	
	private ArrayList<Game> games;
	
	public int createGame(String gamename){
		Game newGame = new Game(gamename);
		games.add(newGame);
		return newGame.getGameID();
		
	}
	
	public void closeGame(Game game){
		games.remove(game);
	}
	
	public void closeInactivGames(){
		
	}
	
	public ArrayList<Game> getGames(){
		return games;
	}
	
	public void addGamerToGame(Gamer gamer, String gameID){
		Game game = getGameByID(gameID);
		game.addGamer(gamer);
	}

	private Game getGameByID(String gameID) {
		return getGameByID(Integer.parseInt(gameID));
	}

	private Game getGameByID(int gameID) {
		for(Game g : games){
			if(g.getGameID() == gameID){
				return g;
			}
		}
		return null;
	}
	
	

}