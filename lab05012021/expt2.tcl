#Create a simulator object
set ns [new Simulator]

#Define different colors for data flow (for NAM)

$ns color 1 Blue
$ns color 2 Red

# open the NAM and TRACE files
#Trace file
set tf1 [open expt2.tr w]
set winfile [open WinFile w]
$ns trace-all $tf1
#Nam file
set nm1 [ open expt2.nam w]
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

proc create-topology {} {
        global ns n0 n1 n2 n3 n4 n5
	set lan [$ns newLan "$n3 $n4 $n5" 0.5Mb 40ms LL Queue/DropTail Mac/Csma/Cd Channel] 

	# Create the links between the nodes

	$ns duplex-link $n0 $n2 2Mb 10ms RED
	$ns duplex-link $n1 $n2 2Mb 10ms RED
	$ns duplex-link $n2 $n3 300Kb 10ms DropTail
}

#create 06 nodes

set n0 [$ns node]
set n1 [$ns node]
set n2 [$ns node]
set n3 [$ns node]
set n4 [$ns node]
set n5 [$ns node]


create-topology

#Give node position (for NAM)

$ns duplex-link-op $n0 $n2 orient right-down
$ns duplex-link-op $n1 $n2 orient right-up
$ns duplex-link-op $n2 $n3 orient right

#Set queue size in the link 6 & 9

$ns queue-limit $n2 $n3 20


# Setup a TCP connection (ftp1-tcp1-sink1)  

set tcp1 [new Agent/TCP]
$ns attach-agent $n0 $tcp1
set sink1 [new Agent/TCPSink]
$ns attach-agent $n4 $sink1
$ns connect $tcp1 $sink1
$tcp1 set fid_ 1
$tcp1 set packetSize_ 500

set ftp1 [new Application/FTP]
$ftp1 attach-agent $tcp1 


#Setup UDP connection

set udp1 [new Agent/UDP]
$ns attach-agent $n1 $udp1
set null1 [new Agent/Null]
$ns attach-agent $n5 $null1
$ns connect $udp1 $null1
$udp1 set fid_ 2

#setup a cbr over udp connection

set cbr1 [new Application/Traffic/CBR]
$cbr1 attach-agent $udp1
$cbr1 set packetSize_ 1000
$cbr1 set rate_ 100Kb
#$cbr set random_ false

# Schedule  

$ns at 1.0 "$ftp1 start"
$ns at 1.5 "$cbr1 start"
$ns at 124.0 "$ftp1 stop"
$ns at 124.5 "$cbr1 stop"

# Printing the window size
proc plotWindow {tcp1 file} {
global ns
set time 0.01
set now [$ns now]
set cwnd [$tcp1 set cwnd_]
puts $file "$now $cwnd"
$ns at [expr $now+$time] "plotWindow $tcp1 $file" }
$ns at 1.1 "plotWindow $tcp1 $winfile"

$ns at 126.0 "finish"

$ns run
