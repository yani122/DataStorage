/*
 * The MIT License (MIT)
 * Copyright (c) 2020 Leif Lindbäck
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction,including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so,subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */


/*
att köra programmet 
query1
tryck 1
skriv det instrument som du letar efter ex:guitar

query2

tryck 2
skriv in sedan student id
sedan skriv in instrument  id du väljer att hyra

query 3

tryck 3
tryck in student id  för den studenten som vill terminera sin instrument
sedan tryck in det instrument id som du önskar att terminera

*/
package se.kth.iv1351.jdbcintro;

import java.sql.*;
import java.util.*;
import java.sql.Connection;
import java.sql.DatabaseMetaData;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;



//basic jdbc program till musicschool  

public class BasicJdbc {

    public static void main(String[] args) {

    new BasicJdbc().accessDB();
  }

    private Scanner input;

    //att göra konekt till musicschools data basen 
       private Connection createConnection() throws SQLException, ClassNotFoundException {
    Class.forName("org.postgresql.Driver");
    return DriverManager.getConnection("jdbc:postgresql://localhost:5432/musicdb",
      "postgres", "postgres");

  }

        //att gå ut från  applikationen  
       private void exitApplication(Connection connection) {
    System.out.println("\n(ENTER)");
    input.nextLine();
  }
          

      private void accessDB() {



    try (Connection connection = createConnection()) {
      input = new Scanner(System.in);
      listCommands(connection);
    }
    catch (SQLException | ClassNotFoundException sqle) {
      sqle.printStackTrace();
    }
  }
    
      
      

      //första guery för att lista ut instrument som är lediga
    private void query1(Connection connection) {
    System.out.print("\nInstrument kind: ");
    
    String instrument = input.nextLine();
    

    try {
      connection.setAutoCommit(false);
      
      //lediga instrument
      PreparedStatement availInstrumentque = connection.prepareStatement("SELECT * FROM instrument_rental AS IR WHERE IR.is_rented = '0' AND IR.kind='" + instrument + "' ORDER BY IR.kind");
      ResultSet availInstrument = availInstrumentque.executeQuery();

      System.out.println("\nAvailable instrument that you can rent:");

      while (availInstrument.next()) {
          
        //printa ut  
    String type = availInstrument.getString("kind");
                String price = availInstrument.getString("price");
                String brand = availInstrument.getString("brand");
                System.out.println("Brand: " + brand + " | " + "Instrument: " + type + " | " + "Fee: " + price);

       
                
      }
      //avslutar nuvarande trnsaktion + parameter ändringar som görs i transaktion
      connection.commit();
      exitApplication(connection);
    }
    catch (SQLException sqle) {
        
        // hantera exceptions och errors
      sqle.printStackTrace();
    }
    finally {
      try {
        connection.setAutoCommit(true);
      }
      catch (SQLException sqle) {
           //hantera exceptions och errors
        sqle.printStackTrace();
      }
    }
  }


    private void query2(Connection connection) {
         System.out.print("\nStudent_id: ");
         //skriv student id 
         String stud = input.nextLine();
      
    try {
        
        
      connection.setAutoCommit(false);
      

     
    //att se hur många instrument som är rentade från studenten 
      PreparedStatement rentedInstNumberQue = connection.prepareStatement("SELECT COUNT(*) FROM rental_lease AS Rl WHERE Rl.student_id=" + stud + " AND Rl.is_terminated='0' ");
      ResultSet rentedInstNumber = rentedInstNumberQue.executeQuery();

      rentedInstNumber.next();
      //om det är mindre än 2
      if (Integer.parseInt(rentedInstNumber.getString(1)) < 2) {
        System.out.print("\nID of the instrument you want to rent: ");
        //id of instrument som studenten väljer
        String inst_id = input.nextLine();

        PreparedStatement validInstQue = connection.prepareStatement("SELECT is_rented FROM instrument_rental AS R WHERE id=" + inst_id);
        ResultSet validInst = validInstQue.executeQuery();

        if (validInst.next()) {
            //om de lika med 0
          if (validInst.getString(1).equals("0")) {
            PreparedStatement rentInstQue = connection.prepareStatement("UPDATE instrument_rental SET is_rented='1' WHERE id=" + inst_id);
            rentInstQue .executeUpdate();
            
            //välj unik id för rental_lease 
            System.out.print("\nID of rental_lease: ");
           String id_rental = input.nextLine();

            PreparedStatement createRentalQuery = connection.prepareStatement("INSERT INTO rental_lease VALUES (" + id_rental + ", " + inst_id + ", " + stud + ", CURRENT_TIMESTAMP(0) , NULL, '0')");
            createRentalQuery.executeUpdate();

             //avslutar nuvarande trnsaktion + parameter ändringar som görs i transaktion
            connection.commit();
            System.out.println("the instrument is rented now.");
            exitApplication(connection); 
          }
          //else det är räntad redan 
          else {
            System.out.println("you can not rent this one this instrument is already rented.");
            connection.rollback();
            exitApplication(connection);
          }
        }
        //du har anget fel
        else {
          System.out.println("Invalid ID WRONG...");
          connection.rollback();
          exitApplication(connection);
        }
      }
      //sista att man har rentad maximalt antal instrument 
      else {
        System.out.println("\nYou have already rented the maximum allowed number of instruments.");
        connection.rollback();
        exitApplication(connection);
      }

    }
    catch (SQLException sqle) {
        //hantera exceptions och errors
      sqle.printStackTrace();
    }
    finally {
      try {
        connection.setAutoCommit(true);
      }
      catch (SQLException sqle) {
          //hantera exceptions och errors
        sqle.printStackTrace();
      }
    }
  }



     private void query3(Connection connection) {
    try {
      connection.setAutoCommit(false);
      
       System.out.print("\nStudent id: ");
       //skriv student id
           String id_s = input.nextLine();

           //instrument som är rentade av studenten 
      PreparedStatement rentedInstQue = connection.prepareStatement("SELECT instrument_rental.id, instrument_rental.kind, instrument_rental.brand FROM instrument_rental INNER JOIN rental_lease  ON instrument_rental.id =rental_lease.instrument_rental_id WHERE student_id=" + id_s + " AND is_terminated='0'");
      ResultSet rentedInst = rentedInstQue .executeQuery();

      String rentedIds = "";
      System.out.println();

      while (rentedInst.next()) {
        System.out.println("ID: " + rentedInst.getString(1) + ", " + rentedInst.getString(2) + ", " + rentedInst.getString(3));
        rentedIds = rentedIds.concat("-" + rentedInst.getString(1) + "- ");
      }

      System.out.print("\nID of rental instrument: ");
      //skriv id för instrument di vill terminera 
      String id = input.nextLine();

      if (rentedIds.contains("-" + id + "-")) {
          //updatering i data basen så den blir orentad instrument
        PreparedStatement upUnrentInstrQue = connection.prepareStatement("UPDATE instrument_rental SET is_rented='0' WHERE id=" + id);
        upUnrentInstrQue.executeUpdate();

        //updatering i databasen och den blir terminerad instrument 
        PreparedStatement terminateTheRentQue = connection.prepareStatement("UPDATE rental_lease SET date_end_time=CURRENT_TIMESTAMP(0), is_terminated='1' WHERE instrument_rental_id=" + id + " AND is_terminated='0'");
        terminateTheRentQue.executeUpdate();
        
 //avslutar nuvarande trnsaktion + parameter ändringar som görs i transaktion
        connection.commit();
        System.out.println("\nThe rental is terminated now.");
      }
      else {
        connection.rollback();
        System.out.println("Invalid ID WRONG...");
      }

      exitApplication(connection);
    }
    catch (SQLException sqle) {
        //hantera exceptions och errors
      sqle.printStackTrace();
    }
    finally {
      try {
        connection.setAutoCommit(true);
      }
      catch (SQLException sqle) {
          //hantera exceptions och errors
        sqle.printStackTrace();
      }
    }
  }


     //lista för att välja mellan olika querys
     private void listCommands(Connection connection) {
    System.out.println("welcome to Soungood music school");
    System.out.println("\n--list of all commands--\n" +
         "1: List of available instrument\n" +
         "2: rents an instrument\n" +
         "3: Terminate rental of specified instrument\n" +
         "4: leave the application" +
         "\n");
    System.out.print(":");
    
    String s = input.nextLine();

    switch (s) {
        //query 1
      case "1":
        query1(connection);
        listCommands(connection);
      break;
      //query2
      case "2":
        query2(connection);
        listCommands(connection);
      break;
      //query 3
      case "3":
        query3(connection);
        listCommands(connection);
      break;
      //stänga av programet 
      case "4":
        System.out.println("Exit\n");
      break;
      //fel siffra
      default:
        System.out.println("try again invalid input.");
        listCommands(connection);
      break;
    }
  } 
        
     
}


/*

f {
      try {
        connection.setAutoCommit(true);
      }
      catch (SQLException sqle) {
          //hantera exceptions och errors
        sqle.printStackTrace();
      }
    }
*/