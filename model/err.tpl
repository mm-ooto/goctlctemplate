package {{.pkg}}

import (
	"errors"
	"github.com/zeromicro/go-zero/core/stores/sqlx"
)

var ErrNotFound = sqlx.ErrNotFound

// ErrAffectedRowsIsZero 更新数据影响行数为0
var ErrAffectedRowsIsZero = errors.New("the number of affected rows is 0")


var (
	// DelStateNo 软删除:0-未删除
	DelStateNo  int64 = 0 
	// DelStateYes 软删除:0-已删除
	DelStateYes int64 = 1 
)
