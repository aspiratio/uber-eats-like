import "./App.css";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

import { Foods } from "./containers/Foods";
import { Orders } from "./containers/Orders";
import { Restaurants } from "./containers/Restaurants";

function App() {
  return (
    <Router>
      <Switch>
        {/* 店舗一覧ページ */}
        <Route exact path="/restaurants">
          <Restaurants />
        </Route>
        {/* フード一覧ページ */}
        <Route
          exact
          path="/restaurants/:restaurantsId/foods"
          render={({ match }) => <Foods match={match} />}
        />
        {/* 注文一覧ページ */}
        <Route exact path="/orders">
          <Orders />
        </Route>
        <Route
          exact
          path="/restaurants/:restaurantsId/foods"
          render={({ match }) => <Foods match={match} />}
        />
      </Switch>
    </Router>
  );
}

export default App;
