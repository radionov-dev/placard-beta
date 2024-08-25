@if ($paginator->hasPages())
<div class="pagination">
    <div class="pagination__items">
        {{-- Previous Page Link --}}
        @if ($paginator->onFirstPage())
            <!--a class="pagination__item">&laquo;</a-->
        @else
            <a class="pagination__item" href="{{ $paginator->previousPageUrl() }}" rel="prev">&laquo;</a>
        @endif

        {{-- Pagination Elements --}}
        @foreach ($elements as $element)
            {{-- "Three Dots" Separator --}}
            @if (is_string($element))
                <a class="pagination__item">{{ $element }}</a>
            @endif

            {{-- Array Of Links --}}
            @if (is_array($element))
                @foreach ($element as $page => $url)
                    @if ($page == $paginator->currentPage())
                        <a class="pagination__item active">{{ $page }}</a>
                    @else
                        <?php if($page > ($paginator->currentPage()+3) or ($paginator->currentPage()-3) > $page) continue; ?>
                        <a class="pagination__item" href="{{ $url }}">{{ $page }}</a>
                    @endif
                @endforeach
            @endif
        @endforeach

        {{-- Next Page Link --}}
        @if ($paginator->hasMorePages())
            <a class="pagination__item" href="{{ $paginator->nextPageUrl() }}" rel="next">&raquo;</a>
        @else
            <!--a class="pagination__item">&raquo;</a-->
        @endif
    </div>
</div>
@endif
