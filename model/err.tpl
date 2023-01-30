package {{.pkg}}

import (
	"errors"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var ErrNotFound = sqlx.ErrNotFound

// ErrAffectedRowsIsZero 更新数据影响行数为0
var ErrAffectedRowsIsZero = errors.New("the number of affected rows is 0")

// SelectBuilder 构建SQL SELECT语句。
// 注意：如果columns不为空并且接收参数的字段个数大于columns就会报错，解决办法是自定义用于接收的参数（不要使用生成的model）
func SelectBuilder(table,rows string, columns ...[]string) squirrel.SelectBuilder {
	var sb squirrel.SelectBuilder
	if len(columns) > 0 {
		sb = squirrel.Select(columns[0]...).From(table)
	} else {
		sb = squirrel.Select(rows).From(table)
	}
	return sb
}

// CountBuilder 构建SQL COUNT语句。
func CountBuilder(table, field string) squirrel.SelectBuilder {
	return squirrel.Select("COUNT(" + field + ")").From(table)
}

// SumBuilder 构建SQL SUM语句。
func SumBuilder(table, field string) squirrel.SelectBuilder {
	return squirrel.Select("IFNULL(SUM(" + field + "),0)").From(table)
}






