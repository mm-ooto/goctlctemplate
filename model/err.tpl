package {{.pkg}}

import (
	"errors"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var ErrNotFound = sqlx.ErrNotFound

// ErrAffectedRowsIsZero 更新数据影响行数为0
var ErrAffectedRowsIsZero = errors.New("the number of affected rows is 0")
