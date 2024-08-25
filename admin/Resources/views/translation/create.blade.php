@extends('panel::layouts.master')

@section('content')
    <div class="container">

        <a href="{{route('panel.translations.index')}}" class="mb-1"><i class="fa fa-angle-left" aria-hidden="true"></i> back</a>

        <div class="row mb-3">
            <div class="col-sm-8">
                    <h2 class="mt-xxs">Adding new translation</h2>
            </div>
            <div class="col-sm-4">

            </div>

        </div>

        <div class="row">

            <div class="col-sm-10">

                <div class="panel panel-default">
                    <div class="panel-body">
    <div class="row">

        <div class="col-sm-12">

          <div class="panel panel-default">
              <div class="panel-body">

                  <div class="form-group">

    <label class="control-label">Select Language</label>
        <select class="form-control" onchange="location=this.value">
            <option value=""></option>
            @foreach($langs as $k => $language_option )
            <option value="{{ route('panel.translations.edit', strtolower($k)) }}">{{$language_option['name']}}</option>
            @endforeach
        </select>


        </div>
</div>
</div>
</div>

                    </div>
                </div>
            </div>
            </div>
        </div>
    </div>


@endsection
