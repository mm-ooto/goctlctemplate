

# 自定义的 goctl 模板内容
注意：默认情况（在不指定--home）goctl会从 ~/.goctl 目录下读取</br>
如果本地没有 ~/.goctl/文件，可以通过模板初始化命令goctl template init进行初始化（如下）：
```shell
E:\Workspace\go\src\github.com\mm-ooto\goctlctemplate>goctl template init
Templates are generated in C:\Users\Li\.goctl\1.4.2, edit on your risk!
```
完整的模板目录结构如下：
```shell
PS C:\Users\MO> tree .\.goctl\
C:\USERS\MO\.GOCTL
├─1.4.2 # 使用命令 goctl template init 生成的初始化模板
│  ├─api
│  ├─docker
│  ├─kube
│  ├─model
│  ├─mongo
│  ├─newapi
│  └─rpc
├─cache
└─template # 使用命令 goctl template init --home $HOME/template 生成的自定义模板
    ├─api
    ├─docker
    ├─kube
    ├─model
    ├─mongo
    ├─newapi
    └─rpc
PS C:\Users\MO>
```

## 使用方法
将本地初始化模板中的对应目录中的文件替换成本项目对应的目录中的文件</br>

## model 模板生成代码对比
原始模板生成的代码如下（goctl model mysql ddl-src ./user.sql -dir ./ -c）：
```go
// usermodel.go:
type (
	userModel interface {
		Insert(ctx context.Context, data *User) (sql.Result, error)
		FindOne(ctx context.Context, id int64) (*User, error)
		FindOneByMobile(ctx context.Context, mobile string) (*User, error)
		Update(ctx context.Context, data *User) error
		Delete(ctx context.Context, id int64) error
	}
)
```
自定义模板生成的代码如下（goctl model mysql ddl --home C:\Users\MO\.goctl\template  -src ./user.sql -dir ./ -c）：
```go
// model/usermodel.go:
type (
	userModel interface {
		Insert(ctx context.Context, session sqlx.Session, data *User) (sql.Result, error)
		FindOne(ctx context.Context, id int64) (*User, error)
		FindOneByMobile(ctx context.Context, mobile string) (*User, error)
		Update(ctx context.Context, session sqlx.Session, data *User) error
		Delete(ctx context.Context, session sqlx.Session, id int64) error
	}
)

// model/usermodel_gen.go:

// Trans runs given fn in transaction mode.
func (m *defaultUserModel) Trans(ctx context.Context, fn func(ctx context.Context, session sqlx.Session) error) error {
    return m.TransactCtx(ctx, func(ctx context.Context, session sqlx.Session) error {
        return fn(ctx, session)
    })

}

// RowBuilder sets the FROM clause of the query.
func (m *defaultUserModel) RowBuilder() squirrel.SelectBuilder {
    return squirrel.Select(userRows).From(m.table)
}

// CountBuilder sets the COUNT FROM clause of the query.
func (m *defaultUserModel) CountBuilder(field string) squirrel.SelectBuilder {
    return squirrel.Select("COUNT(" + field + ")").From(m.table)
}

// SumBuilder sets the SUM FROM clause of the query.
func (m *defaultUserModel) SumBuilder(field string) squirrel.SelectBuilder {
    return squirrel.Select("IFNULL(SUM(" + field + "),0)").From(m.table)
}

```


参考：goctl模板 【https://legacy.go-zero.dev/cn/template-cmd.html】


