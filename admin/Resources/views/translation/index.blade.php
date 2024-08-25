@extends('panel::layouts.master')

@section('content')
    <h2>Translations <a href="{{route('panel.translations.create')}}" class="btn btn-link btn-xs"><i class="mdi mdi-plus"></i> Add new</a></h2>

    @include("panel::components.settings_menu")

    @include('alert::bootstrap')

    <table class="table table-sm table-striped">
        <thead class="thead- border-0">
                  		<tr>
                  			<th>Code</th>
                  			<th>Name</th>
                  			<th></th>
                  		</tr>
	</thead>
	<tbody>

		@foreach($translations as $i => $translation )
            <tr>
			<th scope="row">{{$translation}}</th>
			<td>{{$translations_names[$i]}}</td>
			<td><a href="{{ route('panel.translations.edit', $translation) }}">edit</a>
                    <a href="#" ic-target="#main" ic-select-from-response="#main" ic-delete-from="{{ route('panel.translations.destroy', $translation) }}" ic-confirm="Are you sure?" class="text-muted  ml-2"><i class="mdi mdi-close"></i></a>
			</td>
		</tr>
        @endforeach
		@foreach($langs as $code => $country )
			@if(!in_array(strtolower($code), $translations))
			<tr class="text-muted">
			<th scope="row">{{strtolower($code)}}</th>
			<td><?php echo $country['name']; ?></td>
			<td><a href="{{ route('panel.translations.edit', strtolower($code)) }}">Add</a>
			</td>
			</tr>
			@endif
		@endforeach
	</tbody>
	</table>

@stop
