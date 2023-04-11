# Swapy

### Usage

1. Use the same Erlang/Elixir versions used during the development, just to make sure we're on the same page and avoid any sort of deprecated modules/functions on incompatibilities. And I really hope you're using `asdf` to manage your runtime versions, if so, please run:

  ```sh
  asdf install
  ```

2. To download the used libs and get you setup, please run:

  ```sh
  mix setup
  ```

3. Well, there's some tests indeed(not as much as I'd love to) and to see them, please run:

  ```sh
  mix test
  ```

4. To start the application and have it running on port 4000, please run:

  ```sh
  mix phx.server
  ```

5. Now, use your favorite REST Client and send a POST request with the following:

  ```sh
  Endpoint: "http://localhost:4000/api/process_issues"
  ```
  ```sh
  Example params: {"user": "worknenjoy", "repo": "truppie"}
  ```

6. Now, you shall see somehting like the following:
<img width="1483" alt="Screenshot 2023-04-11 at 14 42 01" src="https://user-images.githubusercontent.com/3707769/231246319-447bf613-c80d-4e4c-8d4a-848f7bccd45d.png">

7. And after a day(which can changed in the `@time_interval` module_attribute of `Swapy.FancyJobScheduler` module), you shall receive a webhook asyncronously, like the following:
<img width="1728" alt="Screenshot 2023-04-11 at 14 47 52" src="https://user-images.githubusercontent.com/3707769/231247582-622f7c94-8201-4033-86a4-0cfa0169d521.png">

