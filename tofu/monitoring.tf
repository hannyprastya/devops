# SNS topic for CloudWatch alarms
resource "aws_sns_topic" "alarms" {
  count = var.enable_monitoring && var.alarm_email != "" ? 1 : 0

  name              = "${replace(var.domain_name, ".", "-")}-alarms"
  display_name      = "CloudWatch Alarms for ${var.domain_name}"
  kms_master_key_id = "alias/aws/sns"

  tags = {
    Name = "${var.domain_name}-alarms"
  }
}

# SNS topic subscription
resource "aws_sns_topic_subscription" "alarm_email" {
  count = var.enable_monitoring && var.alarm_email != "" ? 1 : 0

  topic_arn = aws_sns_topic.alarms[0].arn
  protocol  = "email"
  endpoint  = var.alarm_email
}

# CloudWatch alarm for 4xx errors
resource "aws_cloudwatch_metric_alarm" "cloudfront_4xx_errors" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "${var.domain_name}-cloudfront-4xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "4xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "Average"
  threshold           = 5
  alarm_description   = "Triggers when 4xx error rate exceeds 5%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.website.id
  }

  alarm_actions = var.alarm_email != "" ? [aws_sns_topic.alarms[0].arn] : []

  tags = {
    Name = "${var.domain_name}-4xx-errors"
  }
}

# CloudWatch alarm for 5xx errors
resource "aws_cloudwatch_metric_alarm" "cloudfront_5xx_errors" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "${var.domain_name}-cloudfront-5xx-errors"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "5xxErrorRate"
  namespace           = "AWS/CloudFront"
  period              = 300
  statistic           = "Average"
  threshold           = 1
  alarm_description   = "Triggers when 5xx error rate exceeds 1%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.website.id
  }

  alarm_actions = var.alarm_email != "" ? [aws_sns_topic.alarms[0].arn] : []

  tags = {
    Name = "${var.domain_name}-5xx-errors"
  }
}

# CloudWatch alarm for cache hit rate
resource "aws_cloudwatch_metric_alarm" "cloudfront_cache_hit_rate" {
  count = var.enable_monitoring ? 1 : 0

  alarm_name          = "${var.domain_name}-cloudfront-low-cache-hit-rate"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 3
  metric_name         = "CacheHitRate"
  namespace           = "AWS/CloudFront"
  period              = 900
  statistic           = "Average"
  threshold           = 70
  alarm_description   = "Triggers when cache hit rate falls below 70%"
  treat_missing_data  = "notBreaching"

  dimensions = {
    DistributionId = aws_cloudfront_distribution.website.id
  }

  alarm_actions = var.alarm_email != "" ? [aws_sns_topic.alarms[0].arn] : []

  tags = {
    Name = "${var.domain_name}-cache-hit-rate"
  }
}

# CloudWatch Log Group for CloudFront logs (optional)
resource "aws_cloudwatch_log_group" "cloudfront" {
  count = var.enable_monitoring ? 1 : 0

  name              = "/aws/cloudfront/${var.domain_name}"
  retention_in_days = 30
  kms_key_id        = null

  tags = {
    Name = "${var.domain_name}-cloudfront-logs"
  }
}

# CloudWatch dashboard
resource "aws_cloudwatch_dashboard" "website" {
  count = var.enable_monitoring ? 1 : 0

  dashboard_name = "${replace(var.domain_name, ".", "-")}-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "Requests", { stat = "Sum", label = "Total Requests" }]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "CloudFront Requests"
          dimensions = {
            DistributionId = aws_cloudfront_distribution.website.id
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "4xxErrorRate", { stat = "Average", label = "4xx Error Rate" }],
            [".", "5xxErrorRate", { stat = "Average", label = "5xx Error Rate" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "Error Rates"
          yAxis = {
            left = {
              label = "Percentage"
            }
          }
          dimensions = {
            DistributionId = aws_cloudfront_distribution.website.id
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "CacheHitRate", { stat = "Average", label = "Cache Hit Rate" }]
          ]
          period = 300
          stat   = "Average"
          region = "us-east-1"
          title  = "Cache Performance"
          yAxis = {
            left = {
              label = "Percentage"
            }
          }
          dimensions = {
            DistributionId = aws_cloudfront_distribution.website.id
          }
        }
      },
      {
        type = "metric"
        properties = {
          metrics = [
            ["AWS/CloudFront", "BytesDownloaded", { stat = "Sum", label = "Bytes Downloaded" }]
          ]
          period = 300
          stat   = "Sum"
          region = "us-east-1"
          title  = "Data Transfer"
          yAxis = {
            left = {
              label = "Bytes"
            }
          }
          dimensions = {
            DistributionId = aws_cloudfront_distribution.website.id
          }
        }
      }
    ]
  })
}
