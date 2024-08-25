@extends('panel::layouts.master')

@section('content')
    <div class="container">

        <a href="{{route('panel.translations.index')}}" class="mb-1"><i class="fa fa-angle-left" aria-hidden="true"></i> back</a>

        <div class="row mb-3">
            <div class="col-sm-8">
                    <h2 class="mt-xxs">Edit translation</h2>
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
                  <form action="{{ route('panel.translations.update', strtolower($localeCode)) }}" method="post">
                      {{ csrf_field() }}
                  <div class="table-responsive">
                      <table id="translations" class="table table-striped table-bordered table-hover">
                          <thead>
                            <tr>
                            <td class="text-left">Phrase</td>
                            <td class="text-left">Translation</td>
                            <td></td>
                            </tr>
                          </thead>
                          <tbody>
                          <?php $row = 0; ?>
                          @if($translations)
                          @foreach($translations as $phrase => $translation)
                            <tr id="tr-row<?php echo $row; ?>">
                            <td class="text-left"><input type="text" name="tr[<?php echo $row; ?>][phrase]" value="<?php echo $phrase; ?>" placeholder="Phrase" class="form-control"></td>
                            <td class="text-left"><input type="text" name="tr[<?php echo $row; ?>][translation]" value="<?php echo $translation; ?>" placeholder="Translation" class="form-control"></td>
                            <td class="text-left"><button type="button" onclick="$('#tr-row<?php echo $row; ?>').remove();" class="btn btn-danger">remove</button></td>
                            </tr>
                              <?php $row++; ?>
                          @endforeach
                          @endif
                          </tbody>
                          <tfoot>
                            <tr>
                            <td colspan="2"></td>
                            <td class="text-left"><button type="button" onclick="addTr();"  class="btn btn-primary" >Add</button></td>
                            </tr>
                            </tfoot>
                      </table>
                  </div>
                  <button class="btn btn-primary" type="submit">Submit</button>
                  </form>

        </div>
</div>
</div>
</div>

                    </div>
                </div>
            </div>
            </div>
        </div>


    <script type="text/javascript">
        let _row_=<?php echo $row; ?>;
        function addTr(){
            let html='<tr id="tr-row'+_row_+'">';
            html+='  <td class="text-left"><input type="text" name="product_image['+_row_+'][phrase]" value="" placeholder="Phrase" class="form-control" /></td>';
            html+='  <td class="text-left"><input type="text" name="product_image['+_row_+'][translation]" value="" placeholder="Translations" class="form-control" /></td>';
            html+='  <td class="text-left"><button type="button" onclick="$(\'#tr-row'+_row_+'\').remove();" class="btn btn-danger">remove</button></td>';
            html+='</tr>';
            $('#translations tbody').append(html);
            _row_++;
        }
    </script>
@endsection
