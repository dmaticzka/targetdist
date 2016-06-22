require(ggplot2)
require(gridExtra)

# set theme
theme_set(
        theme_bw() +
        theme(
                text=element_text(family="Helvetica", size=24),
                panel.border = element_rect(fill = NA, colour = NA),
                strip.background = element_rect(fill = NA, colour = NA)
                )
        )

args <- commandArgs(trailingOnly=T)

names = args[seq(3,length(args))]

d <- read.table(args[1], head=F, col.names=c("target", "count", "id"))

order_targets=names
d$target <- factor(d$target, levels=order_targets, ordered=T)

# target_colours = c(
#     "roX1"    = "#3465a4",
#     "roX2"    = "#EF2929",
#     "CR41602" = "#4E9A06",
#     "rRNA"    = "#73d216",
#     "snoRNA"  = "#75507b",
#     "snRNA"   = "#ad7fa8",
#     "ncRNA"   = "#2e3436",
#     "tRNA"    = "#babdb6",
#     "3UTR"    = "#c4a000",
#     "5UTR"    = "#edd400",
#     "exon"    = "#f57900",
#     "intron"  = "#fcaf3e")

# plot fractions (scaled to 1)
p1 <-
ggplot(d) +
geom_bar(aes(id, fill=target, weight=count), position="fill") +
scale_y_continuous("fraction of X") +
# scale_fill_manual(values = target_colours) +
guides(fill = guide_legend(reverse = TRUE))

# plot actual numbers
# use thousand reads
d$count = d$count/1000
p2 <-
ggplot(d) +
geom_bar(aes(target, fill=target, weight=count)) +
theme(axis.text.x=element_text(angle=70, hjust=1)) +
scale_y_continuous("thousand X") +
theme(legend.position="none") +
# scale_fill_manual(values = target_colours) +
guides(fill = guide_legend(reverse = TRUE))

png(paste(sep='', args[2],'.png'), w=800, h=500, units='px')
grid.arrange(p2,p1,ncol=2)
dev.off()

pdf(paste(sep='', args[2],'.pdf'), w=ceiling(800/70), h=ceiling(500/70))
grid.arrange(p2,p1,ncol=2)
dev.off()
