import React, { Component } from "react";
import "./Footer.css";

class Footer extends React.Component {
  render() {
    return (
      <div className="footer-wrapper">
        <div className="footer-item">
          <h1>Logo</h1>
          <p>
            Lorem ipsum dolor sit amet, consectetur adipisicing elit. Expedita
            repudiandae neque illum aspernatur fugiat maiores id magni, modi,
            quaerat vitae. Consectetur
          </p>
        </div>
        <div className="footer-item">
          <h1>Contact</h1>
          <ul>
            <li>
              <p>Call: +76 (094) 754 43 7I</p>
            </li>
            <li>
              <p>Timing: Everyday from 10am - 11pm</p>
            </li>
            <li>
              <p>Address: 817 N California Ave Chicago, IL </p>
            </li>
          </ul>
        </div>
      </div>
    );
  }
}

export default Footer;
