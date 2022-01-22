import React, { Component } from "react";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import "./App.css";
import Navbar from "./components/Navbar";
import Footer from "./components/Footer";
import { UserContext } from "./contexts/UserContext";

import Items from "./pages/Items";
import Manufactures from "./pages/Manufactures";
import Types from "./pages/Types";
import Customers from "./pages/Customers";

import Login from "./pages/Login";
import Register from "./pages/Register";
import NewTypePage from "./pages/NewTypePage";

import AccountPage from "./pages/AccountPage";

function App() {
  return (
    <div className="App">
      <UserContext.Consumer>
        {({ logoutUser }) => {
          return <Navbar onLogoutUser={logoutUser} />;
        }}
      </UserContext.Consumer>
      <Switch>
        <Route
          path="/type/create"
          exact
          render={(props) => <NewTypePage {...props} />}
        />
        <Route path="/items" exact render={(props) => <Items {...props} />} />
        <Route path="/types" exact render={(props) => <Types {...props} />} />
        <Route
          exact
          path="/manufactures"
          render={(props) => <Manufactures {...props} />}
        />
        <Route
          exact
          path="/customers"
          render={(props) => <Customers {...props} />}
        />
        <Route
          exact
          path="/account"
          render={(props) => <AccountPage {...props} />}
        />
        <Route exact path="/login" render={(props) => <Login {...props} />} />
        <Route
          exact
          path="/register"
          render={(props) => <Register {...props} />}
        />
      </Switch>
      <Footer />
    </div>
  );
}

export default App;
