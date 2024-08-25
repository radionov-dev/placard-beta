<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Spatie\SchemalessAttributes\SchemalessAttributes;

class Widget extends Model
{
    use \Spiritix\LadaCache\Database\LadaCacheTrait;
    protected $fillable = [
        'name', 'hash', 'order', 'parent_id', 'slug'
    ];

    protected $casts = [
        'metadata' => 'array',
    ];

    protected $appends = ['meta_values'];

    public function getMetaValuesAttribute(): SchemalessAttributes
    {
        return SchemalessAttributes::createForModel($this, 'meta');
    }

}
