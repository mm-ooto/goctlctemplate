package {{.pkg}}
{{if .withCache}}
import (
	"context"
	"fmt"
	"github.com/pkg/errors"

	"github.com/Masterminds/squirrel"
	"github.com/zeromicro/go-zero/core/stores/cache"
	"github.com/zeromicro/go-zero/core/stores/sqlc"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)
{{else}}
import (
	"context"
	"fmt"
	"github.com/pkg/errors"

	"github.com/zeromicro/go-zero/core/stores/sqlx"
	"github.com/Masterminds/squirrel"
)

{{end}}
var _ {{.upperStartCamelObject}}Model = (*custom{{.upperStartCamelObject}}Model)(nil)


type (
	// {{.upperStartCamelObject}}Model is an interface to be customized, add more methods here,
	// and implement the added methods in custom{{.upperStartCamelObject}}Model.
	{{.upperStartCamelObject}}Model interface {
		{{.lowerStartCamelObject}}Model
		Trans(ctx context.Context,fn func(context context.Context,session sqlx.Session) error) error
		// DeleteSoft(ctx context.Context,session sqlx.Session, data *{{.upperStartCamelObject}}) error
		FindOneByQuery(ctx context.Context,selectBuilder squirrel.SelectBuilder) (*{{.upperStartCamelObject}},error)
		FindSum(ctx context.Context,sumBuilder squirrel.SelectBuilder) (float64,error)
		FindCount(ctx context.Context,countBuilder squirrel.SelectBuilder) (int64,error)
		FindAll(ctx context.Context,selectBuilder squirrel.SelectBuilder,orderBy string) ([]*{{.upperStartCamelObject}},error)
		FindPageListByPage(ctx context.Context,selectBuilder squirrel.SelectBuilder,page ,pageSize int64,orderBy string) ([]*{{.upperStartCamelObject}},error)
		FindPageListByIdDESC(ctx context.Context,selectBuilder squirrel.SelectBuilder ,preMinId ,pageSize int64) ([]*{{.upperStartCamelObject}},error)
		FindPageListByIdASC(ctx context.Context,selectBuilder squirrel.SelectBuilder,preMaxId ,pageSize int64) ([]*{{.upperStartCamelObject}},error)
		BatchInsert(ctx context.Context, session sqlx.Session, data []map[string]interface{}) error
		BatchUpdateByWhere(ctx context.Context, session sqlx.Session, where map[string]interface{}, SetData map[string]interface{}) error
		BatchUpdateCase(ctx context.Context, session sqlx.Session, where map[string]interface{}, data []map[string]interface{}, fieldKey string) error

}

	custom{{.upperStartCamelObject}}Model struct {
		*default{{.upperStartCamelObject}}Model
	}
)

// New{{.upperStartCamelObject}}Model returns a model for the database table.
func New{{.upperStartCamelObject}}Model(conn sqlx.SqlConn{{if .withCache}}, c cache.CacheConf{{end}}) {{.upperStartCamelObject}}Model {
	return &custom{{.upperStartCamelObject}}Model{
		default{{.upperStartCamelObject}}Model: new{{.upperStartCamelObject}}Model(conn{{if .withCache}}, c{{end}}),
	}
}



// Trans Trans
func (m *default{{.upperStartCamelObject}}Model) Trans(ctx context.Context,fn func(ctx context.Context,session sqlx.Session) error) error {
	{{if .withCache}}
	return m.TransactCtx(ctx,func(ctx context.Context,session sqlx.Session) error {
		return  fn(ctx,session)
	})
	{{else}}
	return m.conn.TransactCtx(ctx,func(ctx context.Context,session sqlx.Session) error {
		return  fn(ctx,session)
	})
	{{end}}
}

// 如有需要，请自行实现 UpdateWithVersion
// func (m *default{{.upperStartCamelObject}}Model) DeleteSoft(ctx context.Context,session sqlx.Session,data *{{.upperStartCamelObject}}) error {
// 	data.DelState = DelStateYes
// 	if err:= m.UpdateWithVersion(ctx,session, data);err!= nil{
// 		return err
// 	}
// 	return nil
// }

// FindOneByQuery FindOneByQuery
func (m *default{{.upperStartCamelObject}}Model) FindOneByQuery(ctx context.Context,selectBuilder squirrel.SelectBuilder) (*{{.upperStartCamelObject}},error) {

	query, values, err := selectBuilder.ToSql()
	if err != nil {
		return nil, err
	}

	var resp {{.upperStartCamelObject}}
	{{if .withCache}}err = m.QueryRowNoCacheCtx(ctx,&resp, query, values...){{else}}
	err = m.conn.QueryRowCtx(ctx,&resp, query, values...)
	{{end}}
	switch err {
	case nil:
		return &resp, nil
	case sqlc.ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, err
	}
}

// FindSum FindSum
func (m *default{{.upperStartCamelObject}}Model) FindSum(ctx context.Context,sumBuilder squirrel.SelectBuilder) (float64,error) {

	query, values, err := sumBuilder.ToSql()
	if err != nil {
		return 0, err
	}

	var resp float64
	{{if .withCache}}err = m.QueryRowNoCacheCtx(ctx,&resp, query, values...){{else}}
	err = m.conn.QueryRowCtx(ctx,&resp, query, values...)
	{{end}}
	switch err {
	case nil:
		return resp, nil
	default:
		return 0, err
	}
}

// FindCount FindCount
func (m *default{{.upperStartCamelObject}}Model) FindCount(ctx context.Context,countBuilder squirrel.SelectBuilder) (int64,error) {

	query, values, err := countBuilder.ToSql()
	if err != nil {
		return 0, err
	}

	var resp int64
	{{if .withCache}}err = m.QueryRowNoCacheCtx(ctx,&resp, query, values...){{else}}
	err = m.conn.QueryRowCtx(ctx,&resp, query, values...)
	{{end}}
	switch err {
	case nil:
		return resp, nil
	default:
		return 0, err
	}
}

// FindAll FindAll
func (m *default{{.upperStartCamelObject}}Model) FindAll(ctx context.Context,selectBuilder squirrel.SelectBuilder,orderBy string) ([]*{{.upperStartCamelObject}},error) {

	if orderBy == ""{
		selectBuilder = selectBuilder.OrderBy("id DESC")
	}else{
		selectBuilder = selectBuilder.OrderBy(orderBy)
	}

	query, values, err := selectBuilder.ToSql()
	if err != nil {
		return nil, err
	}

	var resp []*{{.upperStartCamelObject}}
	{{if .withCache}}err = m.QueryRowsNoCacheCtx(ctx,&resp, query, values...){{else}}
	err = m.conn.QueryRowsCtx(ctx,&resp, query, values...)
	{{end}}
	switch err {
	case nil:
		return resp, nil
	case sqlc.ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, err
	}
}

// FindPageListByPage FindPageListByPage
func (m *default{{.upperStartCamelObject}}Model) FindPageListByPage(ctx context.Context,selectBuilder squirrel.SelectBuilder,page ,pageSize int64,orderBy string) ([]*{{.upperStartCamelObject}},error) {

	if orderBy == ""{
		selectBuilder = selectBuilder.OrderBy("id DESC")
	}else{
		selectBuilder = selectBuilder.OrderBy(orderBy)
	}

	if page < 1{
		page = 1
	}
	offset := (page - 1) * pageSize

	query, values, err := selectBuilder.Offset(uint64(offset)).Limit(uint64(pageSize)).ToSql()
	if err != nil {
		return nil, err
	}

	var resp []*{{.upperStartCamelObject}}
	{{if .withCache}}err = m.QueryRowsNoCacheCtx(ctx,&resp, query, values...){{else}}
	err = m.conn.QueryRowsCtx(ctx,&resp, query, values...)
	{{end}}
	switch err {
	case nil:
		return resp, nil
	case sqlc.ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, err
	}
}

// FindPageListByIdDESC FindPageListByIdDESC
func (m *default{{.upperStartCamelObject}}Model) FindPageListByIdDESC(ctx context.Context,selectBuilder squirrel.SelectBuilder ,preMinId ,pageSize int64) ([]*{{.upperStartCamelObject}},error) {

	if preMinId > 0 {
		selectBuilder = selectBuilder.Where(" id < ? " , preMinId)
	}

	query, values, err := selectBuilder.OrderBy("id DESC").Limit(uint64(pageSize)).ToSql()
	if err != nil {
		return nil, err
	}

	var resp []*{{.upperStartCamelObject}}
	{{if .withCache}}err = m.QueryRowsNoCacheCtx(ctx,&resp, query, values...){{else}}
	err = m.conn.QueryRowsCtx(ctx,&resp, query, values...)
	{{end}}
	switch err {
	case nil:
		return resp, nil
	case sqlc.ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, err
	}
}

// FindPageListByIdASC 按照id升序分页查询数据，不支持排序
func (m *default{{.upperStartCamelObject}}Model) FindPageListByIdASC(ctx context.Context,selectBuilder squirrel.SelectBuilder,preMaxId ,pageSize int64) ([]*{{.upperStartCamelObject}},error)  {

	if preMaxId > 0 {
		selectBuilder = selectBuilder.Where(" id > ? " , preMaxId)
	}

	query, values, err := selectBuilder.OrderBy("id ASC").Limit(uint64(pageSize)).ToSql()
	if err != nil {
		return nil, err
	}

	var resp []*{{.upperStartCamelObject}}
	{{if .withCache}}err = m.QueryRowsNoCacheCtx(ctx,&resp, query, values...){{else}}
	err = m.conn.QueryRowsCtx(ctx,&resp, query, values...)
	{{end}}
	switch err {
	case nil:
		return resp, nil
	case sqlc.ErrNotFound:
		return nil, ErrNotFound
	default:
		return nil, err
	}
}

// BatchInsert 批量插入
func (m *default{{.upperStartCamelObject}}Model) BatchInsert(ctx context.Context, session sqlx.Session, data []map[string]interface{}) error {

	query, value, err := sqlBuilder.BuildInsert(m.table, data)
	if err != nil {
		return err
	}

	_, err = m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (sql.Result, error) {
		if session != nil {
			return session.ExecCtx(ctx, query, value...)
		}
		return conn.ExecCtx(ctx, query, value...)
	})

	if err != nil {
		return err
	}

	return nil
}


// BatchUpdateByWhere 批量更新
func (m *default{{.upperStartCamelObject}}Model) BatchUpdateByWhere(ctx context.Context, session sqlx.Session, where map[string]interface{}, SetData map[string]interface{}) error {

	query, value, err := squirrel.Update(m.table).SetMap(SetData).Where(where).ToSql()
	if err != nil {
		return err
	}

	_, err = m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (sql.Result, error) {
		if session != nil {
			session.ExecCtx(ctx, query, value...)
		}
		return conn.ExecCtx(ctx, query, value...)
	})
	if err != nil {
		return err
	}

	return nil
}

// BatchUpdateCase 根据指定条件批量更新数据
func (m *default{{.upperStartCamelObject}}Model) BatchUpdateCase(ctx context.Context, session sqlx.Session, where map[string]interface{}, data []map[string]interface{}, fieldKey string) error {
	if len(fieldKey) == 0 {
		return errors.New("params error")
	}
	updateBuilder := squirrel.Update(m.table).Where(where)
	whenMap := map[string][]map[interface{}]interface{}{}

	for _, datum := range data {
		fieldKeyValue, ok := datum[fieldKey]
		if !ok {
			return errors.New("params error")
		}
		switch fieldKeyValue.(type) {
		case string, squirrel.Sqlizer:
		default:
			fieldKeyValue = fmt.Sprintf("%v", fieldKeyValue)
		}

		for column, columnValue := range datum {
			if column == fieldKey {
				continue
			}

			if _, ok = whenMap[column]; !ok {
				whenMap[column] = []map[interface{}]interface{}{}
			}
			switch columnValue.(type) {
			case squirrel.Sqlizer:
			default:
				columnValue = fmt.Sprintf("'%v'", columnValue)
			}
			whenMap[column] = append(whenMap[column], map[interface{}]interface{}{fieldKeyValue: columnValue})
		}
	}

	for column, whenList := range whenMap {
		caseBuilder := squirrel.Case(fieldKey)
		for _, when := range whenList {
			for fieldKeyValue, columnValue := range when {
				caseBuilder = caseBuilder.When(fieldKeyValue, columnValue)
			}
		}

		updateBuilder = updateBuilder.Set(column, caseBuilder)
	}

	query, values, err := updateBuilder.ToSql()
	if err != nil {
		return err
	}
	_, err = m.ExecCtx(ctx, func(ctx context.Context, conn sqlx.SqlConn) (sql.Result, error) {
		if session != nil {
			return session.ExecCtx(ctx, query, values...)
		}
		return conn.ExecCtx(ctx, query, values...)
	})
	if err != nil {
		return err
	}
	return nil
}
