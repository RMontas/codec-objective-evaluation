import argparse
from parse import *
from pylab import *
from matplotlib.backends.backend_pdf import PdfPages

parser = argparse.ArgumentParser(description="Script for RD Curves")
parser.add_argument("SEQ", type=str)
parser.add_argument("main_dir_MY", type=str)
parser.add_argument("main_dir_REF0", type=str)
parser.add_argument("main_dir_REF1", type=str)
parser.add_argument("flag_ref", type=int)

args = parser.parse_args()
if args.flag_ref == 1:
	pdfname = "res_rd_curves_" + args.SEQ + "_" + args.main_dir_REF0 + "_vs_" + args.main_dir_MY + "_vs_" + args.main_dir_REF1 + "/RD_Curves.pdf"
else:
	pdfname = "res_rd_curves_" + args.SEQ + "_" + args.main_dir_REF0 + "_vs_" + args.main_dir_MY + "/RD_Curves.pdf"

output_pdf = PdfPages(pdfname)

# find input video
fo=0
if args.SEQ == "PT0": 
        h = 1088
        w = 1920
        mw = 28
        mh = 28
        sequence_name = "Plane and Toy"
	total_pixelsi = h * w
elif args.SEQ == "PT150":
        h = 1088
        w = 1920
        mw = 28
        mh = 28
        sequence_name = "Plane and Toy"
        fo = 150
elif args.SEQ == "LAURA":
        h = 5432
        w = 7240
        mw = 75
        mh = 75
        sequence_name = "Laura"
elif args.SEQ == "SEAGULL":
        h = 5432
        w = 7240
        mw = 75
        mh = 75
        sequence_name = "Seagull"
elif args.SEQ == "DS":
        w = 2880 
        h = 1620 
        mw = 38
        mh = 38
        sequence_name = "Demichelis Spark"
elif args.SEQ == "DC":
        w = 2880 
        h = 1620 
        mw = 38
        mh = 38
        sequence_name = "Demichelis Cut"
elif args.SEQ == "1BIKES":
	w = 7728
	h = 5368
	mw = 15
	mh = 15
	sequence_name = "Bikes"
elif args.SEQ == "2DANGER":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Danger de Mort"
elif args.SEQ == "3FLOWERS":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Flowers"
elif args.SEQ == "4STONE":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Stone Pillars Outside"
elif args.SEQ == "5VESPA":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Vespa"
elif args.SEQ == "6ANKY":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Ankylosaurus & Diplodocus 1"
elif args.SEQ == "7DESKTOP":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Desktop"
elif args.SEQ == "8MAGNETS":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Magnets 1"
elif args.SEQ == "9FOUNTAIN":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Fountain & Vincent 2"
elif args.SEQ == "10FRIENDS":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Friends 1"
elif args.SEQ == "11COLOR":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "Color chart 1"
elif args.SEQ == "12ISO":
        w = 7728
        h = 5368
        mw = 15
        mh = 15
        sequence_name = "ISO Chart 12"
elif args.SEQ == "PT150_FAST":
        w = 176
        h = 144
        mw = 28
        mh = 28
        sequence_name = "QCIF Plane and Toy (frame 150)"
elif args.SEQ == "PT150_RECT":
        h = 1064
        w = 1904
        mw = 28
        mh = 28
        sequence_name = "Plane and Toy RECT"
        fo = 150
elif args.SEQ == "LAURA_RECT":
        h = 5400
        w = 7200
        mw = 75
        mh = 75
        sequence_name = "Laura RECT"
elif args.SEQ == "SEAGULL_RECT":
        h = 5400
        w = 7200
        mw = 75
        mh = 75
        sequence_name = "Seagull RECT"
elif args.SEQ == "DS_RECT":
        w = 2850
        h = 1558
        mw = 38
        mh = 38
        sequence_name = "Demichelis Spark RECT"
elif args.SEQ == "DC_RECT":
        w = 2850
        h = 1558
        mw = 38
        mh = 38
        sequence_name = "Demichelis Cut RECT"
elif args.SEQ == "PT0_RECT":
        h = 1064
        w = 1904
        mw = 28
        mh = 28
        sequence_name = "Plane and Toy RECT"


total_pixels = h * w
num_QP=6

psnr_my=[0 for i in range(num_QP)]
bit_my=[0 for i in range(num_QP)]
psnr_ref0=[0 for i in range(num_QP)]
bit_ref0=[0 for i in range(num_QP)]
if args.flag_ref == 1:
	psnr_ref1=[0 for i in range(num_QP)]
	bit_ref1=[0 for i in range(num_QP)]


fREF0_bits = open(args.main_dir_REF0 + "/" + args.SEQ + "/" + args.main_dir_REF0 + "_bits.txt", "r")
fREF0_psnr = open(args.main_dir_REF0 + "/" + args.SEQ + "/" + args.main_dir_REF0 + "_psnr.txt", "r")
fMY_bits = open(args.main_dir_MY + "/" + args.SEQ + "/" + args.main_dir_MY + "_bits.txt", "r")
fMY_psnr = open(args.main_dir_MY + "/" + args.SEQ + "/" + args.main_dir_MY + "_psnr.txt", "r")
if args.flag_ref == 1:
	fREF1_bits = open(args.main_dir_REF1 + "/" + args.SEQ + "/" + args.main_dir_REF1 + "_bits.txt", "r")
	fREF1_psnr = open(args.main_dir_REF1 + "/" + args.SEQ + "/" + args.main_dir_REF1 + "_psnr.txt", "r")

l=0
for line in fREF0_bits:
	bit_ref0[l] = double(line)/total_pixels
	l = l + 1
num_QP_REF0 = 0
for line in fREF0_psnr:
        psnr_ref0[num_QP_REF0] = double(line)
        num_QP_REF0 = num_QP_REF0 + 1
l=0
for line in fMY_bits:
        bit_my[l] = double(line)/total_pixels
        l = l + 1
num_QP_MY = 0
for line in fMY_psnr:
        psnr_my[num_QP_MY] = double(line)
        num_QP_MY = num_QP_MY + 1
if args.flag_ref == 1:
	l=0
	for line in fREF1_bits:
        	bit_ref1[l] = double(line)/total_pixels
        	l = l + 1
	num_QP_REF1 = 0
	for line in fREF1_psnr:
        	psnr_ref1[num_QP_REF1] = double(line)
        	num_QP_REF1 = num_QP_REF1 + 1

fREF0_bits.close()
fREF0_psnr.close()
fMY_bits.close()
fMY_psnr.close()
if args.flag_ref == 1:
	fREF1_bits.close()
	fREF1_psnr.close()
print num_QP_REF0
print num_QP_MY
plot(bit_ref0[0:num_QP_REF0],psnr_ref0[0:num_QP_REF0], "r",marker="o", label=args.main_dir_REF0)
plot(bit_my[0:num_QP_MY],psnr_my[0:num_QP_MY], "b",marker="o", label=args.main_dir_MY)
grid(True)
legend(loc = 4,prop={'size':6})
xlabel("Rate (bit/pixel)")
ylabel("PSNR (dB)")
title_name = sequence_name + " " + str(w) + "x" + str(h) + ", MI:" + str(mw) + "x" + str(mh)
title(title_name)
output_pdf.savefig()
clf()


if args.flag_ref == 1:
	plot(bit_ref0[0:num_QP_REF0],psnr_ref0[0:num_QP_REF0], "r",marker="o", label=args.main_dir_REF0)
	plot(bit_ref1[0:num_QP_REF1],psnr_ref1[0:num_QP_REF1], "g",marker="o", label=args.main_dir_REF1)
	plot(bit_my[0:num_QP_MY],psnr_my[0:num_QP_MY], "b",marker="o", label=args.main_dir_MY)
	grid(True)
	legend(loc = 4,prop={'size':6})
	xlabel("Rate (bit/pixel)")
	ylabel("PSNR (dB)")
	title_name = sequence_name + " " + str(w) + "x" + str(h) + ", MI:" + str(mw) + "x" + str(mh)
	title(title_name)
	output_pdf.savefig()
	clf()
	
	plot(bit_ref0[0:num_QP_REF0],psnr_ref0[0:num_QP_REF0], "r",marker="o", label=args.main_dir_REF0)
        plot(bit_ref1[0:num_QP_REF1],psnr_ref1[0:num_QP_REF1], "g",marker="o", label=args.main_dir_REF1)
	grid(True)
        legend(loc = 4,prop={'size':6})
        xlabel("Rate (bit/pixel)")
        ylabel("PSNR (dB)")
        title_name = sequence_name + " " + str(w) + "x" + str(h) + ", MI:" + str(mw) + "x" + str(mh)
        title(title_name)
        output_pdf.savefig()
        clf()

output_pdf.close()




























