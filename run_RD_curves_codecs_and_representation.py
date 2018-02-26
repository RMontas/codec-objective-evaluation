import argparse
from parse import *
from pylab import *
from matplotlib.backends.backend_pdf import PdfPages

def get_seq_data(SEQ):

        if SEQ == "PT0":
                return 1088, 1920, 28, 28, "Plane and Toy", 0
        elif SEQ == "PT150":
                return 1088, 1920, 28, 28, "Plane and Toy", 150
        elif SEQ == "LAURA" :
                return 5432, 7240, 75, 75, "Laura", 0
        elif SEQ == "SEAGULL":
                return 5432, 7240, 75, 75, "Seagull", 0
        elif SEQ == "DS":
                return 2880, 1620, 38, 38, "Demichelis Spark", 0
        elif SEQ == "DC":
                return 2880, 1620, 38, 38, "Demichelis Cut", 0

        elif SEQ == "1BIKES":
                return 7728, 5368, 15, 15, "Bikes", 0
        elif SEQ == "2DANGER":
                return 7728, 5368, 15, 15, "Danger de Mort", 0
        elif SEQ == "3FLOWERS":
                return 7728, 5368, 15, 15, "Flowers", 0
        elif SEQ == "4STONE":
                return 7728, 5368, 15, 15, "Stone Pillars Outside", 0
        elif SEQ == "5VESPA":
                return 7728, 5368, 15, 15, "Vespa", 0
        elif SEQ == "6ANKY":
                return 7728, 5368, 15, 15, "Ankylosaurus & Diplodocus 1", 0
        elif SEQ == "7DESKTOP":
                return 7728, 5368, 15, 15, "Desktop", 0
        elif SEQ == "8MAGNETS":
                return 7728, 5368, 15, 15, "Magnets 1", 0
        elif SEQ == "9FOUNTAIN":
                return 7728, 5368, 15, 15, "Fountain & Vincent 2", 0
        elif SEQ == "10FRIENDS":
                return 7728, 5368, 15, 15, "Friends 1", 0
        elif SEQ == "11COLOR":
                return 7728, 5368, 15, 15, "Color chart 1", 0
        elif SEQ == "12ISO":
                return 7728, 5368, 15, 15, "ISO Chart 12", 0

        elif SEQ == "PT150_FAST":
                return 176, 144, 28, 28, "QCIF Plane and Toy (frame 150)", 0

        elif SEQ == "4DLF_I01_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I01_YUV420_8", 0
        elif SEQ == "4DLF_I02_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I02_YUV420_8", 0
        elif SEQ == "4DLF_I03_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I03_YUV420_8", 0
        elif SEQ == "4DLF_I04_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I04_YUV420_8", 0
        elif SEQ == "4DLF_I05_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I05_YUV420_8", 0
        elif SEQ == "4DLF_I06_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I06_YUV420_8", 0
        elif SEQ == "4DLF_I07_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I07_YUV420_8", 0
        elif SEQ == "4DLF_I08_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I08_YUV420_8", 0
        elif SEQ == "4DLF_I09_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I09_YUV420_8", 0
        elif SEQ == "4DLF_I10_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I10_YUV420_8", 0
        elif SEQ == "4DLF_I11_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I11_YUV420_8", 0
        elif SEQ == "4DLF_I12_YUV420_8":
                return 9376, 6512, 15, 15, "4DLF_I12_YUV420_8", 0

	elif SEQ == "4DLF_PVS_I01_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I01_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I02_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I02_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I03_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I03_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I04_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I04_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I05_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I05_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I06_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I06_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I07_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I07_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I08_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I08_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I09_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I09_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I10_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I10_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I11_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I11_YUV420_8", 0
        elif SEQ == "4DLF_PVS_I12_YUV420_8":
                return 632, 440, 15, 15, "4DLF_PVS_I12_YUV420_8", 0

	elif SEQ == "4DLF_13x13_I01_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I01_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I02_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I02_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I03_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I03_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I04_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I04_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I05_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I05_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I06_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I06_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I07_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I07_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I08_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I08_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I09_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I09_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I10_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I10_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I11_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I11_YUV420_8", 0
        elif SEQ == "4DLF_13x13_I12_YUV420_8":
                return 8128, 5648, 13, 13, "4DLF_13x13_I12_YUV420_8", 0

        elif SEQ == "4DLF_13x13_PVS_I01_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I01_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I02_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I02_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I03_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I03_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I04_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I04_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I05_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I05_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I06_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I06_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I07_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I07_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I08_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I08_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I09_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I09_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I10_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I10_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I11_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I11_YUV420_8", 0
        elif SEQ == "4DLF_13x13_PVS_I12_YUV420_8":
                return 632, 440, 13, 13, "4DLF_13x13_PVS_I12_YUV420_8", 0

parser = argparse.ArgumentParser(description="Script for RD Curves")
parser.add_argument("SEQ_MY", type=str)
parser.add_argument("main_dir_MY", type=str)
parser.add_argument("SEQ_REF", type=str)
parser.add_argument("main_dir_REF", type=str)
parser.add_argument("psnr_type", type=str)

args = parser.parse_args()

if args.psnr_type == "0": # GLOBAL PSNR
	pdfname = "res_rd_curves_" + args.SEQ_MY + "_" + args.main_dir_MY + "_vs_" + args.SEQ_REF + "_" + args.main_dir_REF + "/RD_Curves.pdf"
elif args.psnr_type == "1": # AVG PSNR Y (views)
	pdfname = "res_rd_curves_PSNR_Y_" + args.SEQ_MY + "_" + args.main_dir_MY + "_vs_" + args.SEQ_REF + "_" + args.main_dir_REF + "/RD_Curves.pdf"
elif args.psnr_type == "2": # AVG PSNR YUV (views)
        pdfname = "res_rd_curves_PSNR_YUV_" + args.SEQ_MY + "_" + args.main_dir_MY + "_vs_" + args.SEQ_REF + "_" + args.main_dir_REF + "/RD_Curves.pdf"

output_pdf = PdfPages(pdfname)

# find input video
h_MY, w_MY, mw_MY, mh_MY, sequence_name_MY, fo_MY = get_seq_data(args.SEQ_MY)
total_pixels_MY = h_MY * w_MY
h_REF, w_REF, mw_REF, mh_REF, sequence_name_REF, fo_REF = get_seq_data(args.SEQ_REF)
total_pixels_REF = h_REF * w_REF
num_QP=6

psnr_my=[0 for i in range(num_QP)]
bit_my=[0 for i in range(num_QP)]
psnr_ref0=[0 for i in range(num_QP)]
bit_ref0=[0 for i in range(num_QP)]

fREF0_bits = open(args.main_dir_REF + "/" + args.SEQ_REF + "/" + args.main_dir_REF + "_bits.txt", "r")
fMY_bits = open(args.main_dir_MY + "/" + args.SEQ_MY + "/" + args.main_dir_MY + "_bits.txt", "r")
if args.psnr_type == "0": # GLOBAL PSNR
	fREF0_psnr = open(args.main_dir_REF + "/" + args.SEQ_REF + "/" + args.main_dir_REF + "_psnr.txt", "r")
	fMY_psnr = open(args.main_dir_MY + "/" + args.SEQ_MY + "/" + args.main_dir_MY + "_psnr.txt", "r")
elif args.psnr_type == "1": # AVG PSNR Y (views)
	fREF0_psnr = open(args.main_dir_REF + "/" + args.SEQ_REF + "/" + args.main_dir_REF + "_avg_psnr_y.txt", "r")
        fMY_psnr = open(args.main_dir_MY + "/" + args.SEQ_MY + "/" + args.main_dir_MY + "_avg_psnr_y.txt", "r")
elif args.psnr_type == "2": # AVG PSNR YUV (views)
	fREF0_psnr = open(args.main_dir_REF + "/" + args.SEQ_REF + "/" + args.main_dir_REF + "_avg_psnr_yuv.txt", "r")
        fMY_psnr = open(args.main_dir_MY + "/" + args.SEQ_MY + "/" + args.main_dir_MY + "_avg_psnr_yuv.txt", "r")

l=0
for line in fREF0_bits:
	#bit_ref0[l] = double(line)/total_pixels_REF
	bit_ref0[l] = double(line)
	l = l + 1
num_QP_REF0 = 0
for line in fREF0_psnr:
        psnr_ref0[num_QP_REF0] = double(line)
        num_QP_REF0 = num_QP_REF0 + 1
l=0
for line in fMY_bits:
        #bit_my[l] = double(line)/total_pixels_MY
	bit_my[l] = double(line)
        l = l + 1
num_QP_MY = 0
for line in fMY_psnr:
        psnr_my[num_QP_MY] = double(line)
        num_QP_MY = num_QP_MY + 1

fREF0_bits.close()
fREF0_psnr.close()
fMY_bits.close()
fMY_psnr.close()

print num_QP_REF0
print num_QP_MY
plot(bit_ref0[0:num_QP_REF0],psnr_ref0[0:num_QP_REF0], "r",marker="o", label=args.main_dir_REF)
plot(bit_my[0:num_QP_MY],psnr_my[0:num_QP_MY], "b",marker="o", label=args.main_dir_MY)
grid(True)
legend(loc = 4,prop={'size':6})
xlabel("Rate (bits)")
ylabel("PSNR (dB)")
title_name = sequence_name_REF + " " + str(w_REF) + "x" + str(h_REF) + ", MI:" + str(mw_REF)
title(title_name)
output_pdf.savefig()
clf()

output_pdf.close()


