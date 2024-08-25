<?php

namespace App\Traits;

use App\Models\BitDeals;
use App\Models\Comment;

trait Commentable
{

    /**
     * @return \Illuminate\Database\Eloquent\Relations\MorphMany
     */
    public function comments()
    {
        return $this->hasMany(Comment::class);
    }

    /**
     * @return bool
     */
    public function getCanBeRated()
    {
        return (isset($this->canBeRated)) ? $this->canBeRated : false;
    }

    /**
     * @return bool
     */
    public function mustBeApproved()
    {
        return (isset($this->mustBeApproved)) ? $this->mustBeApproved : false;
    }

    /**
     * @return mixed
     */
    public function totalCommentCount()
    {
        return ($this->mustBeApproved()) ? $this->comments()->where('approved', true)->count() : $this->comments()->count();
    }

    /**
     * @return float
     */
    public function averageRate()
    {

        $response = (array)BitDeals::user_profile(array('address' => $this->bitcoin));
        if (isset($response['seller']) || isset($response['customer'])) {
            $count = (!empty($response['seller']['count'])?$response['seller']['count']:0)+(!empty($response['customer']['count'])?$response['customer']['count']:0);
            $positive = (!empty($response['seller']['positive'])?$response['seller']['positive']:0)+(!empty($response['customer']['positive'])?$response['customer']['positive']:0);

            return $count?(($positive*3)+($count-$positive))/$count:0;
        }

        return ($this->getCanBeRated()) ? $this->comments()->where('approved', true)->avg('rate') : 0;
    }
}
