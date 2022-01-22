import React, { Component } from "react";
import $ from "jquery";
import ManufactureCard from "../components/ManufactureCard";
import "./Manufactures.css";

class Manufactures extends React.Component {
  constructor(props) {
    super(props);
    this.state = {
      manufactures: [],
    };
  }

  componentDidMount = async () => {
    const userToken = JSON.parse(window.localStorage.getItem("userToken"));
    const settings = {
      method: "GET",
      timeout: 0,
      url: `http://localhost/manufactures`,
      headers: {
        token: userToken,
      },
    };

    let response = await $.ajax(settings);
    response = JSON.parse(response);
    console.log(response);
    if (response.status == 200) {
      const manufactures = response.response;
      this.setState({ manufactures });
    } else {
      alert("Error");
    }
  };
  render() {
    return (
      <div>
        <h1>Manufactures</h1>
        <div className="manufactures-wrapper">
          {this.state.manufactures.map((manufacture) => (
            <ManufactureCard key={manufacture.Name} manufacture={manufacture} />
          ))}
        </div>
      </div>
    );
  }
}

export default Manufactures;
