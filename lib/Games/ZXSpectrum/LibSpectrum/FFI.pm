use strict;
use warnings;
package Games::ZXSpectrum::LibSpectrum::FFI;
use base qw/ Exporter /;

use FFI::Platypus 2.00;
use FFI::CheckLib 0.25 qw/ find_lib_or_exit /;

our $VERSION = '0.00';

# ABSTRACT: Bindings for libspectrum - File handling and other utilities for ZX Spectrum emulation

my $typedefs;
my $libspectrum_error;
my $binds;

my $ffi;
sub _load_libspectrum {
    $ffi = FFI::Platypus->new(
        api => 2,
        lib => [
            find_lib_or_exit(
                lib   => 'spectrum',
                alien => 'Alien::libspectrum'
            )
        ]
    );
}

sub _init {
    
}

sub _defines {
    my ( @consts ) = @_;
    my $const = 0;
    { map { $_ => $const++ } @consts }
}

BEGIN {
    _load_libspectrum();

    $typedefs = { qw/
         uint8_t libspectrum_byte
          int8_t libspectrum_signed_byte
        uint16_t libspectrum_word
         int16_t libspectrum_signed_word
        uint32_t libspectrum_dword
         int32_t libspectrum_signed_dword
        uint64_t libspectrum_qword
         int64_t libspectrum_signed_qword
    / };

    $libspectrum_error = _defines( qw/
        LIBSPECTRUM_ERROR_NONE
        LIBSPECTRUM_ERROR_WARNING
        LIBSPECTRUM_ERROR_MEMORY
        LIBSPECTRUM_ERROR_UNKNOWN
        LIBSPECTRUM_ERROR_CORRUPT
        LIBSPECTRUM_ERROR_SIGNATURE
        LIBSPECTRUM_ERROR_SLT
        LIBSPECTRUM_ERROR_INVALID
    / );
    $libspectrum_error->{ LIBSPECTRUM_ERROR_LOGIC } = -1;

    $binds = {
        libspectrum_zlib_inflate => [ [ 'libspectrum_byte*', 'size_t', 'libspectrum_byte**', 'size_t*' ] => 'libspectrum_error' ],
        libspectrum_zlib_compress => [ [ 'libspectrum_byte*', 'size_t', 'libspectrum_byte**', 'size_t*' ] => 'libspectrum_error' ],

        libspectrum_init => [ [ 'void' ] => 'libspectrum_error' ],
        libspectrum_end  => [ [ 'void' ] => 'libspectrum_end' ],

        libspectrum_check_version  => [ [ 'string' ] => 'int' ],
        libspectrum_version        => [ [ 'void' ] => 'string' ],
        libspectrum_gcrypt_version => [ [ 'void' ] => 'string' ],

        
    };
}

1;
