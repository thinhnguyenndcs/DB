import React, { Component } from "react";
import { BrowserRouter as Router, Switch, Route, Link } from "react-router-dom";
import "./Navbar.css";
import { withRouter } from "react-router-dom";

class Navbar extends React.Component {
  handleLogoutUser = async () => {
    const response = await this.props.onLogoutUser();
    this.props.history.replace("/login");
  };

  render() {
    const { currentLoginUser, onLogoutUser } = this.props;
    return (
      <div>
        <nav className="navbar py-3 navbar-expand-lg navbar-dark bg-dark">
          <a className="navbar-brand" href="#">
            Employee
          </a>
          <button
            className="navbar-toggler"
            type="button"
            data-toggle="collapse"
            data-target="#navbarSupportedContent"
            aria-controls="navbarSupportedContent"
            aria-expanded="false"
            aria-label="Toggle navigation"
          >
            <span className="navbar-toggler-icon"></span>
          </button>

          <div className="collapse navbar-collapse" id="navbarSupportedContent">
            {window.localStorage.getItem("userToken") && (
              <ul className="navbar-nav mr-auto">
                {false && (
                  <li>
                    <Link className="nav-link" to="/order">
                      <i className="bi bi-cart3"></i>
                    </Link>
                  </li>
                )}
                <li>
                  <Link className="nav-link" to="/items">
                    Items
                  </Link>
                </li>
                <li>
                  <Link className="nav-link" to="/types">
                    Types
                  </Link>
                </li>
                <li>
                  <Link className="nav-link" to="/manufactures">
                    Manufactures
                  </Link>
                </li>
                <li>
                  <Link className="nav-link" to="/customers">
                    Customers
                  </Link>
                </li>
              </ul>
            )}
          </div>

          <div className="collapse navbar-collapse" id="navbarSupportedContent">
            {!window.localStorage.getItem("userToken") && (
              <ul className="navbar-nav ml-auto">
                <li>
                  <Link className="nav-link" to="/login">
                    Login
                  </Link>
                </li>
                <li>
                  <Link className="nav-link" to="/register">
                    Register
                  </Link>
                </li>
              </ul>
            )}

            {window.localStorage.getItem("userToken") && (
              <ul className="navbar-nav ml-auto">
                <li>
                  <Link className="nav-link" to="/account">
                    Account
                  </Link>
                </li>
                <li>
                  <a className="nav-link" onClick={this.handleLogoutUser}>
                    Logout
                  </a>
                </li>
              </ul>
            )}
          </div>
        </nav>
      </div>
    );
  }
}

export default withRouter(Navbar);
