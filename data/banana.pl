#!/usr/bin/env perl

#banana graph generator

use strict;
use warnings;

eval {
	package Point;
	use strict;
	use warnings;

	use Carp;
	use POSIX;
	use Data::Dumper;
	use overload
	'+' => \&plus,
	'!=' => \&isnot,
	'==' => \&is,
	'-' => \&minus,
	'*' => \&times,
	'""' => \&signature,
	'<' => \&less_than,
	'<=' => \&less_than_equal,
	'<=>' => \&less_equal_more,
	'cmp' => \&compare;

	my $precision = 8;
	my $delta = 5 * 10**(-($precision+1));

	sub new {
		my $class = shift;
		my $self = [@_];
		for (@{$self}) {
			confess "invalid coordinate $_" unless /\d+(\.\d+)?/;
		}
		bless($self, $class);
		return $self;
	}

	sub copy {
		my $self = shift;
		return new Point($self->get_coordinates());
	}

	sub plus {
		my $a = shift;
		my $b = shift;
		confess 'not same type of points' unless $#{$a} == $#{$b};
		my @coordinates;
		push @coordinates, $a->[$_] + $b->[$_] for (0..$#{$a});
		return new Point(@coordinates);
	}

	sub times {
		my $a = shift;
		my $b = shift;
		my $p;
		my $s;
		if(ref $a eq 'Point') {
			$p = $a;
			$s = $b;
		} else {
			$p = $b;
			$s = $a;
		}
		my @coordinates;
		push @coordinates, $p->[$_] * $s for (0..$#{$p});
		return new Point(@coordinates);
	}

	sub minus {
		my $a = shift;
		my $b = shift;
		return $a + -1*$b;
	}

	sub get_x { return $_[0]->[0] }
	sub get_y { return $_[0]->[1] }
	sub get_coordinates { return @{$_[0]} }

#Taken from http://www.perlmonks.org/?node_id=656450

	sub rotate {
		my $self = shift;
		my $angle = shift;
		confess 'no angle in point rotation' unless defined $angle;
		confess 'rotate only works on 2d points' unless @{$self}==2;
		my $x = $self->[0];
		my $y = $self->[1];
		my $c = cos(-$angle);
		my $s = sin(-$angle);
		return new Point($x*$c - $y*$s, $x*$s + $y*$c);
	}

	sub isnot {
		my $a = shift;
		my $b = shift;
		return not (is($a,$b));
	}

	sub is {
		my ($a, $b) = @_;
		for my $index (0..$#{$a}) {
			my $c1 = $a->[$index];
			my $c2 = $b->[$index];
			if (abs($c1 - $c2) > $delta) {
				return 0;
			}
		}
		return 1;
	}

	sub signature {
		my $self = shift;
		return join(' ', @{$self});
	}

	sub less_equal_more {
		my $a = shift;
		my $b = shift;
		return -1 if $a < $b;
		return 1 if $b < $a;
		return 0;
	}

	sub less_than {
		my $a = shift;
		my $b = shift;
		confess 'not same type of points' unless $#{$a} == $#{$b};
		for my $index (0..$#{$a}) {
			return 1 if $a->[$index] < $b->[$index];
			return 0 if $a->[$index] > $b->[$index];
		}
		return 0;
	}

	sub compare {
		my $a = shift;
		my $b = shift;
		confess 'not same type of points' unless $#{$a} == $#{$b};
		for my $index (0..$#{$a}) {
			return -1 if $a->[$index] < $b->[$index];
			return 1 if $a->[$index] > $b->[$index];
		}
		return 0;
	}

	sub set_coordinate {
		my $self = shift;
		my $index = shift;
		$self->[$index] = shift;
	}

	sub get_coordinate {
		my $self = shift;
		my $index = shift;
		return $self->[$index];
	}

	1
};

use constant PI => 4 * atan2(1, 1);

my ($inner_radius, $outer_radius, $inner_degree, $outer_degree) = @ARGV;

die "use: banana.pl inner_radius outer_radius inner_degree outer_degree" unless defined $outer_degree;

my @points;
my $origin = new Point(0, 0);
push @points, $origin;

my %edges;

for my $c (1..$inner_degree) {
	my $inner_point = circle_point($origin, $inner_radius, ($c*2*PI/$inner_degree));
	push @points, $inner_point;
	my $inner_point_index = @points;
	add_edge(1, $inner_point_index);

	#outer points
	for my $c2 (1..$outer_degree) {
		my $angle;
		if ($outer_degree % 2 == 0) {
			#rotate a bit more to avoid overlapping edges
			$angle = $c*2*PI/$inner_degree + $c2*2*PI/$outer_degree + 2*PI/(2*$outer_degree);
		} else {
			$angle = $c*2*PI/$inner_degree + $c2*2*PI/$outer_degree;
		}
		push @points, circle_point($inner_point, $outer_radius, $angle);
		my $outer_point_index = @points;
		add_edge($inner_point_index, $outer_point_index);
	}
}

my $points_number = @points;
print "$points_number\n";
for my $index (0..$#points) {
	print $points[$index]->get_x().' '.$points[$index]->get_y()."\n";
	my $edges = $edges{$index+1};
	my $edges_count = @{$edges};
	print "$edges_count\n";
	print join(' ', @{$edges})."\n";
}

sub add_edge {
	my ($a, $b) = @_;
	push @{$edges{$a}}, $b;
	push @{$edges{$b}}, $a;
}

sub circle_point {
	my $center = shift;
	my $radius = shift;
	my $angle = shift;
	return $center + $radius*(new Point(cos($angle), sin($angle)));
}
