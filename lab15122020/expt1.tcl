##Create a simulator object
set ns [new Simulator]

#Define different colors for data flow (for NAM)

$ns color 1 Blue
$ns color 2 Red
$ns color 3 Green

# open the NAM and TRACE files

set tf1 [open expt1.tr w]
$ns trace-all $tf1

set nm1 [open expt1.nam w]
$ns namtrace-all $nm1


#Define the finish procedure

proc finish {} {
	global ns tf1 nm1
	$ns flush-trace
 
#close nam and trace file
	close $tf1 
	close $nm1
	
	exit 0
}

#create 10  nodes

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]
set n6 [$ns node]
set n7 [$ns node]
set n8 [$ns node]
set n9 [$ns node]

 


# Create the links between the nodes

$ns duplex-link $n0 $n6 128Mb 10ms RED
$ns duplex-link $n5 $n6 128Mb 10ms RED
$ns duplex-link $n7 $n1 2Mb 10ms RED
$ns duplex-link $n7 $n3 2Mb 10ms RED
$ns duplex-link $n8 $n4 2Mb 10ms RED
$ns duplex-link $n8 $n2 128Mb 10ms RED

$ns duplex-link $n6 $n9 20Mb 10ms DropTail
$ns duplex-link $n9 $n7 20Mb 10ms DropTail
$ns duplex-link $n9 $n8 20Mb 10ms DropTail

#Give node position (for NAM)

$ns duplex-link-op $n0 $n6 orient right-up
$ns duplex-link-op $n5 $n6 orient right-down
$ns duplex-link-op $n6 $n9 orient right
$ns duplex-link-op $n9 $n7 orient right-up
$ns duplex-link-op $n9 $n8 orient right-down
$ns duplex-link-op $n7 $n1 orient right-up
$ns duplex-link-op $n7 $n3 orient right
$ns duplex-link-op $n8 $n4 orient right
$ns duplex-link-op $n8 $n2 orient right-down

#Set queue size in the link 6 & 9

$ns queue-limit $n6 $n9 3

# Setup a TCP connection (ftp1-tcp1-sink1)  

set tcp1 [ new Agent/TCP]
$ns attach-agent $n0 $tcp1

set sink1 [new Agent/TCPSink]
$ns attach-agent $n3 $sink1

$ns connect $tcp1 $sink1

$tcp1 set fid_ 1
#$tcp1 set packetSize_ 552

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1 


# Setup a TCP connection (ftp2-tcp2-sink2)

set tcp2 [ new Agent/TCP]
$ns attach-agent $n1 $tcp2

set sink2 [new Agent/TCPSink]
$ns attach-agent $n4 $sink2

$ns connect $tcp2 $sink2

$tcp2 set fid_ 2
#$tcp1 set packetSize_ 552

set ftp2 [new Application/FTP]
$ftp2 attach-agent $tcp2

#Setup UDP connection

set udp1 [new Agent/UDP]
$ns attach-agent $n2 $udp1

set null1 [new Agent/Null]
$ns attach-agent $n5 $null1

$ns connect $udp1 $null1

$udp1 set fid_ 3

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1

#$cbr set packetSize_ 1000
#$cbr set rate_ 0.1Mb
#$cbr set random_ false

## Schedule

$ns at 0.5 "$ftp1 start"
$ns at 0.5 "$ftp2 start"
$ns at 1.0 "$cbr1 start"
$ns at 10.5 "$ftp1 stop"
$ns at 10.5 "$ftp2 stop"
$ns at 10.0 "$cbr1 stop"

$ns at 11.0 "finish"

$ns run
