#!/usr/bin/perl -w
use strict;
use List::Util qw( min max sum);

sub menu {
    print "Main Menu - please select an option:\n1.) Add a course\n2.) Add a student\n3.) Add result\n4.) View Results\n5.) Quit \nEnter your choice:";
    return <STDIN>;
}
    my ($res,$hash);

START:
    $res->{loopexit} = 'n';
    $res->{main} = menu ();
    print "$res->{main}";
    print "Invalid response select from option: 1-5\n" if($res->{main}>5);

unless ($res->{loopexit} =~ /y/ig) {
#Add Course
    if ($res->{main} == 1) {
        AddCourse ();
        if($hash->{returnstart1} =~ /y/gi) {
            goto START;
        }
    }
#Add Student
    elsif ($res->{main} == 2) {
        AddStudent ();
        if($hash->{returnstart2} =~ /y/gi) {
            goto START;
        }
    }
#Add Result
    elsif ($res->{main} == 3) {
        AddResult ();
        if($hash->{returnstart3} =~ /y/gi) {
            goto START;
        }
    }
#View Result
    elsif ($res->{main} == 4) {
        ViewResult ();
        if($hash->{returnstart4} =~ /y/gi) {
            goto START;
        }
    }
# Quit
    elsif ($res->{main} == 5) {
        print "Thanks for using FedUni Results Manager!\n";
        exit;
    }
}

sub AddCourse {
    my $course;
    print "Please enter course code:";
    $course->{coursecode} = uc <STDIN>;
    chomp($course->{coursecode});

    print "Please enter course name:";
    $course->{coursename} = uc <STDIN>;
    chomp($course->{coursename});

    push (@{$hash->{course}} , $course );

    print "Would you like to [A]dd a new course or [R]eturn to the previous menu?\n";
    $res->{addcourseloop} =<STDIN>;

    chomp($res->{addcourseloop});
    if ($res->{addcourseloop} =~ /A/ig) {
        AddCourse();
    } elsif ($res->{addcourseloop} =~ /R/ig) {
        $hash->{returnstart1} = 'y';
        return $hash;
    }
    return $hash;
}

sub AddStudent {
    my $student;
    my $validstudent = 0;

    while (1) {
        print "Please enter student id:";
        $student->{studentid} = <STDIN>;
        chomp($student->{studentid});
        $validstudent = CheckStudentExist($student->{studentid});
        last if ($validstudent);
    }

    print "Please enter student name:";
    $student->{studentname} = uc <STDIN>;
    chomp($student->{studentname});

    push (@{$hash->{student}} , $student );

    print "Would you like to [A]dd a new student or [R]eturn to the previous menu?\n";
    $res->{addstudentloop} = <STDIN>;
    chomp($res->{addstudentloop});

    if ($res->{addstudentloop} =~ /A/ig) {
        AddStudent();
    }
    if ($res->{addstudentloop} =~ /R/ig) {
        $hash->{returnstart2} = 'y';
    }
    return $hash;
}


sub AddResult {
    my $result;
    my $input;
    my $validstudent = 0;
    my $validcourse = 0;
    while (!$validstudent) {
        print "Please enter student id:\n";
        $input->{studentid} = <STDIN>;
        chomp($input->{studentid});
        $validstudent = CheckStudent($input->{studentid});
    }

    while (!$validcourse) {
        print "Please enter course code:\n";
        $input->{coursecode} = <STDIN>;
        chomp($input->{coursecode});
        $validcourse = CheckCourse(uc($input->{coursecode}));
    }

    if($validstudent && $validcourse) {
        foreach my $datahash(@{$hash->{student}}) {
            my $validscore = 0;
            if($datahash->{studentid} eq $input->{studentid} ) {
                while (!$validscore) {
                    print "Please enter final score:\n";
                    $input->{finalscore} = <STDIN>;
                    chomp($input->{finalscore});
                    $validscore = CheckValidScore($input->{finalscore})
                }
                push (@{$datahash->{stundentresult}}, {course => $input->{coursecode},score => $input->{finalscore}});
            }
        }
    }

        print "Would you like to [A]dd a new result or [R]eturn to the previous menu?\n";
        $res->{addresultloop} =<STDIN>;
        chomp($res->{addresultloop});

        if ($res->{addresultloop} =~ /A/i) {
            AddResult();
        }
        if ($res->{addresultloop} =~ /R/i) {
            $hash->{returnstart3} = 'y';
        }

    return $hash;
}

sub ViewResult {
    my $viewresult;
    print "Would you like to view [C]ourse results, [S]tudent results or [R]eturn?\n";
    $viewresult->{response} = <STDIN>;
    chomp($viewresult->{response});
#Course Result
    if($viewresult->{response} =~ /C/ig){
        my @result;
        my $getres;
        my @printhash;
        my $resulthash;
        my $validcourse = 0;
        # my $validstudent = 0;
        while (!$validcourse) {
            print "Please enter course code:\n";
            $getres->{coursecode} = <STDIN>;
            chomp($getres->{coursecode});
            $validcourse = CheckCourse(uc($getres->{coursecode}));
        }
        foreach my $coursecode (@{$hash->{student}}) {
            $resulthash->{studentid} = $coursecode->{studentid};
            $resulthash->{studentname} = $coursecode->{studentname};
            foreach my $studentdata (@{$coursecode->{stundentresult}}){
                if($studentdata->{course} eq ($getres->{coursecode})) {
                    print "$getres->{coursecode} - $studentdata->{score} \n";
                    $resulthash->{coursecode} = $getres->{coursecode};
                    $resulthash->{score} = $studentdata->{score};
                    push (@result , $studentdata->{score});
                    push (@printhash,$resulthash);
                }
            }
        }
       my $minim = min @result;
       my $maxim = max @result;
       print "Maximum score: $maxim \nMinimum score: $minim \n";
    }

#Student Result
    if($viewresult->{response} =~ /S/i){
        my $validstudent = 0;
        my $resulthash;
        my $input;
        my @result1;
        my @printhash;
        my($min,$max,$avg);
        while (!$validstudent) {
            print "Please enter student id:\n";
            $input->{studentid} = <STDIN>;
            chomp($input->{studentid});
            $validstudent = CheckStudent($input->{studentid});
        }
        foreach my $coursecode (@{$hash->{student}}) {
            if($coursecode->{studentid} eq $input->{studentid}) {
                print "Results for student: ".$input->{studentid}."- ".$coursecode->{studentname}."\n";
                foreach my $studentdata (@{$coursecode->{stundentresult}}){
                        print "$studentdata->{course} - $studentdata->{score}\n";
                        push (@result1 , $studentdata->{score});
                }
            }
        }
        $min = min @result1;
        $max = max @result1;
        $avg = sum (@result1);
        $avg = $avg /(scalar @result1) if($avg);
        print "Maximum score: $max\nMinimum score: $min\nAverage result: $avg\n" if($min || $max || $avg);
    }
    print "Would you like to view [C]ourse results, [S]tudent results or [R]eturn?\n";
    $res->{addresultloop} =<STDIN>;
    chomp($res->{addresultloop});

    if ($res->{addresultloop} =~ /(C|S)/ig) {
        ViewResult();
    }
    if ($res->{addresultloop} =~ /R/ig) {
        $hash->{returnstart4} = 'y';
    }
}

sub CheckStudent {
    my $studentid = shift;
    if(grep {$_->{studentid} eq $studentid} @{$hash->{student}}){
        return 1;
    }
    print "Student does not exist\n";
    return 0;
}

sub CheckStudentExist {
    my $studentid = shift;
    if(grep {$_->{studentid} eq $studentid} @{$hash->{student}}){
        print "Student id exist\n";
        return 0;
    }
    return 1;
}

sub CheckCourse {
    my $courseid = shift;
    if(grep {$_->{coursecode} eq $courseid} @{$hash->{course}}){
        return 1;
    }
    print "Course does not exist\n";
    return 0;
}

sub CheckValidScore {
    my $score = shift;
    if($score >= 0.00 && $score <=100.00){
        return 1;
    }
    print "Score is not between 0.00 and 100.00 inclusive.\n";
    return 0;
}
