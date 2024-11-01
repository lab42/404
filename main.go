package main

import (
	"net/http"

	"github.com/lab42/404/templates"
	"github.com/labstack/echo/v4"
)

func main() {
	e := echo.New()
	e.HideBanner = true
	e.GET("/*", echo.WrapHandler(http.FileServer(http.FS(templates.FS))))
	e.Logger.Fatal(e.Start(":1234"))
}
